from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.core.entity.interface import IEntity
from yogomee.core.entity.entity import Entity
from yogomee.core.entity.unpacker import EntityUnpacker
from yogomee.core.entity.factory import Factory

import interface

class MemoryStorageFactory(object):
    
    implements(interface.IStorageFactory)
    
    def __init__(self):
        self.__entyty_map = {}
        
    def get(self, entity):
        if self.__entyty_map.has_key(entity):
            return defer.succeed(self.__entyty_map[entity])
        storage = MemoryStorage(entity, self)
        self.__entyty_map[entity] = storage
        return defer.succeed(storage)

class MemoryStorage(object):
    
    implements(interface.IStorage)
    
    def __init__(self, entity, factory):
        self.entity = IEntity(entity)
        self.factory = Factory(self.entity)
        self.storageFactory = interface.IStorageFactory(factory)
        self.unpacker = EntityUnpacker(self.entity)
        self.id_cache = {}
        self.id_map = {}
        self.index_map = {}
        self.fields_storages = {}
        self.fields_unpackers = {}
        for field in filter(lambda field: IEntity.providedBy(field.type), self.entity.fields()):
            self.fields_unpackers[field.name] = EntityUnpacker(field.type)
        for field in self.entity.indexed_fields():
            self.index_map[field.name] = {}
        self.initialized = False
        self.initd = None
    
    def init(self, *args):
        
        if self.initialized:
            return defer.succeed(True)
        
        if self.initd is not None:
            return self.initd
        
        def get_storages(_):
            
            def get_storage(field):
                
                def set_storage(storage):
                    self.fields_storages[field.name] = storage
                    return defer.succeed(storage)
                
                d = self.storageFactory.get(field.type)
                d.addCallback(set_storage)
                return d
            
            fields = filter(lambda field: IEntity.providedBy(field.type), self.entity.fields())
            dlist = map(lambda field: get_storage(field), fields)
            return defer.DeferredList(dlist, fireOnOneErrback = True)
        
        def complete(_):
            self.initialized = True
            return defer.succeed(True)
        
        self.initd = defer.Deferred()
        self.initd.addCallback(get_storages)
        self.initd.addCallback(complete)
        reactor.callLater(0, self.initd.callback, None)
        return self.initd
            
    def put(self, instance):
            
        def unpack(_):
                
            def unpack_identity(instance):
                return self.unpacker.unpack_identity(instance)
                
            def unpack_indexes(instance):
                    
                def complete(indexes):
                        
                    fields = filter(lambda field: IEntity.providedBy(field.type), self.entity.indexed_fields())
                        
                    if len(fields):
                            
                        def complete(results):
                            for (field, (success, value)) in map(lambda field, result: (field, result), fields, results):
                                if not success:
                                    return defer.fail(value)
                                indexes[field.name] = value
                            return defer.succeed(indexes)
                            
                        dlist = map(lambda field: self.fields_unpackers[field.name].unpack_identity(indexes[field.name]), fields)
                        d = defer.DeferredList(dlist, consumeErrors = True)
                        d.addCallback(complete)
                        return d
                        
                    else:
                        return defer.succeed(indexes)
                    
                d = self.unpacker.unpack_indexed(instance)
                d.addCallback(complete)
                return d
                
            def unpack_required(instance):
                    
                def complete(required):
                        
                    fields = filter(lambda field: IEntity.providedBy(field.type), self.entity.required_fields())
                        
                    if len(fields):
                            
                        def complete(results):
                            for (field, (success, value)) in map(lambda field, result: (field, result), fields, results):
                                if not success:
                                    return defer.fail(value)
                                required[field.name] = value
                            return defer.succeed(required)
                            
                        dlist = map(lambda field: self.fields_unpackers[field.name].unpack_identity(required[field.name]), fields)
                        d = defer.DeferredList(dlist, consumeErrors = True)
                        d.addCallback(complete)
                        return d
                        
                    else:
                        return defer.succeed(required) 
                        
                d = self.unpacker.unpack_required(instance)
                d.addCallback(complete)
                return d
                
            def unpack_optional(instance):
                    
                def complete(optional):
                        
                    fields = filter(lambda field: IEntity.providedBy(field.type), self.entity.optional_fields())
                        
                    if len(fields):
                            
                        def complete(results):
                            for (field, (success, value)) in map(lambda field, result: (field, result), fields, results):
                                if not siccess:
                                    return defer.fail(value)
                                optional[field.name] = value
                            return defer.succeed(optional)
                            
                        dlist = map(lambda field: self.fields_unpackers[field.name].unpack_identity(optional[field.name]), fields)
                        d = defer.DeferredList(dlist, consumeErrors = True)
                        d.addCallback(complete)
                        return d
                            
                    else:
                        return defer.succeed(optional)
                        
                d = self.unpacker.unpack_optional(instance)
                d.addCallback(complete)
                return d
                
            def complete(results):
                rs = ()
                for (success, result) in results:
                    if not success:
                        return defer.fail(result)
                    rs += (result,)
                return defer.succeed(rs)
                
            d = defer.DeferredList([
                                    unpack_identity(instance),
                                    unpack_indexes(instance),
                                    unpack_required(instance),
                                    unpack_optional(instance)
                                    ], consumeErrors = True)
            d.addCallback(complete)
            return d
            
        def put((identity, indexes, required, optional)):
                
            def put_instance((identity, required, optional)):
                self.id_map[identity] = {"required" : required, "optional" : optional}
                return defer.succeed(True)
                
            def put_indexes((identity, indexes)):
                for index in indexes.keys():
                    if not self.index_map[index].has_key(indexes[index]):
                        self.index_map[index][indexes[index]] = {}
                    self.index_map[index][indexes[index]][identity] = 1
                return defer.succeed(True)
                
            def complete(results):
                return defer.succeed(instance)
                
            d = defer.DeferredList([
                                    put_instance((identity, required, optional)),
                                    put_indexes((identity, indexes))
                                    ], consumeErrors = True)
                
            d.addCallback(complete)
            return d
            
        def complete(result):
            return defer.succeed(instance)
            
        d = defer.Deferred()
        
        d.addCallback(self.init)    
        d.addCallback(unpack)
        d.addCallback(put)
        d.addCallback(complete)
            
        reactor.callLater(0, d.callback, None)
        return d
    
    def get(self, identity):
        
        def check_exists(_):
            if self.id_map.has_key(identity):
                return defer.succeed(identity)
            return defer.fail(AttributeError("Entity not exists: %s" % identity))
        
        def get(identity):
            
            if self.id_cache.has_key(identity):
                return defer.succeed((self.id_cache[identity], identity))
            
            def unpack_fields(identity):
                fields = {}
                toFetch = {}
        
                for (name, value) in self.id_map[identity]["required"].items():
                    if self.fields_storages.has_key(name):
                        fields[name] = None
                        toFetch[name] = value
                    else:
                        fields[name] = value
                        
                for (name, value) in self.id_map[identity]["optional"].items():
                    if self.fields_storages.has_key(name):
                        fields[name] = None
                        toFetch[name] = value
                    else:
                        fields[name] = value
       
                return defer.succeed((identity, fields, toFetch))
                
            def create((identity, fields, toFetch)):
                
                def create((identity, fields, toFetch)):
        
                    def complete(instance):
                        setattr(instance, self.entity.identity().name, identity)
                        return defer.succeed((instance, identity, toFetch))
                    
                    d = self.factory.create(**fields)
                    d.addCallback(complete)
                    return d
                
                d = defer.Deferred()
                d.addCallback(create)
                reactor.callLater(0, d.callback, (identity, fields, toFetch))
                return d
            
            def add_to_cache((instance, identity, toFetch)):
                self.id_cache[identity] = instance
                return defer.succeed((instance, identity, toFetch))
            
            def fetch((instance, identity, toFetch)):
                
                if not len(toFetch):
                    return defer.succeed((instance, identity, {}))
                
                def complete(results):
                    fetched = {}
                    for (name, (success, value)) in map(lambda field, result: (field, result), fields, results):
                        fetched[name] = value
                    return defer.succeed((instance, identity, fetched))
                
                fields = toFetch.keys()
                dlist = map(lambda field: self.fields_storages[field].get(toFetch[field]), fields)
                d = defer.DeferredList(dlist, consumeErrors = True)
                d.addCallback(complete)
                return d
            
            def set_fetched((instance, identity, fetched)):
                for (name, value) in fetched.items():
                    setattr(instance, name, value)
                return defer.succeed((instance, identity))
            
            def complete((instance, identity)):
                return defer.succeed((instance, identity))
            
            d = defer.Deferred()
            
            d.addCallback(unpack_fields)
            d.addCallback(create)
            d.addCallback(add_to_cache)
            d.addCallback(fetch)
            d.addCallback(set_fetched)
            d.addCallback(complete)
            
            reactor.callLater(0, d.callback, identity)
            return d
        
        def complete((instance, identity)):
            return defer.succeed(instance)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(check_exists)
        d.addCallback(get)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def where(self, **kwargs):
        
        def calc_index(_):
            return defer.succeed((kwargs.keys()[0], kwargs[kwargs.keys()[0]]))
        
        def get((index, value)):
            
            if Entity.providedBy(value):
                value = value.id
            
            if self.index_map.has_key(index):
                if self.index_map[index].has_key(value):
                    return defer.succeed(self.index_map[index][value].keys())
            return []
        
        def complete(identities):
            return defer.succeed(identities)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(calc_index)
        d.addCallback(get)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d