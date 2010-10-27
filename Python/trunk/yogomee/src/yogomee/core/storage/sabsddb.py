from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.core.entity.interface import IEntity
from yogomee.core.entity.entity import Entity
from yogomee.core.entity.unpacker import EntityUnpacker
from yogomee.core.entity.factory import Factory

import interface

from absddb import adbenv
from absddb import adb
import bsddb.db as db

import pickle

class AbsddbStorageFactory(object):
    
    implements(interface.IStorageFactory)
    
    def __init__(self, path):
        self.__entity_map = {}
        self.path = path
        self.env = adbenv.ADBEnv()
        
        self.initialized = False
        self.initd = None
        
    def init(self, *args):
        
        if self.initialized:
            return defer.succeed(True)
        
        if self.initd is not None:
            return self.initd
        
        def open_env(_):
            return self.env.open(self.path,
                             db.DB_CREATE |
                             db.DB_INIT_MPOOL |
                             db.DB_INIT_LOG |
                             db.DB_INIT_TXN |
                             db.DB_RECOVER)
            
        def complete(_):
            self.initialized = True
            return defer.succeed(True)
        
        self.initd = defer.Deferred()
        
        self.initd.addCallback(open_env)
        self.initd.addCallback(complete)
        
        reactor.callLater(0, self.initd.callback, None)
        return self.initd
    
    def get(self, entity):
        
        if self.__entity_map.has_key(entity):
            return defer.succeed(self.__entity_map[entity])
        
        def get(_):
            storage = AbsddbStorage(entity, self.env, self)
            self.__entity_map[entity] = storage
            return defer.succeed(storage)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(get)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def __del__(self):
        print "close env"
        if self.initialized:
            self.env.close()    
            
    
class AbsddbStorage(object):
    
    implements(interface.IStorage)
    
    def __init__(self, entity, env, factory):
        self.entity = IEntity(entity)
        self.factory = Factory(self.entity)
        self.storageFactory = interface.IStorageFactory(factory)
        self.unpacker = EntityUnpacker(self.entity)
        
        self.id_cache = {}
        
        self.env = env
        self.pdb = adb.ADB(self.env)
        
        self.fields_unpackers = {}
        self.fields_storages = {}
        for field in filter(lambda field: IEntity.providedBy(field.type), self.entity.fields()):
            self.fields_unpackers[field.name] = EntityUnpacker(field.type)
        
        self.idb = {}
        for field in self.entity.indexed_fields():
            self.idb[field.name] = adb.ADB(self.env)
        
        self.initialized = False
        self.initd = None
    
    def init(self, *args):
        
        if self.initialized:
            return defer.succeed(True)
        
        if self.initd is not None:
            return self.initd
        
        def open_pdb(_):
            return self.pdb.open(
                                 "%s.db" % self.entity.__name__,
                                 self.entity.__name__,
                                 db.DB_HASH,
                                 db.DB_CREATE | db.DB_AUTO_COMMIT
                                 )
        
        def set_idb_flags(_):
            dlist = map(lambda name: self.idb[name].set_flags(db.DB_DUP | db.DB_DUPSORT), self.idb.keys())
            return defer.DeferredList(dlist, fireOnOneErrback = True)
        
        def open_idb(_):
            dlist = map(
                        lambda name: self.idb[name].open(
                                                         "%s.idx" % self.entity.__name__,
                                                         name,
                                                         db.DB_BTREE,
                                                         db.DB_CREATE | db.DB_AUTO_COMMIT
                                                         ),
                        self.idb.keys()
                        )
            
            return defer.DeferredList(dlist, fireOnOneErrback = True)
        
        def associate(_):
            
            def create_callback(name):
                def callback(key, data):
                    values = pickle.loads(data)
                    return pickle.dumps(values[name])
                return callback
            
            dlist = map(lambda name: self.pdb.associate(self.idb[name], create_callback(name), db.DB_CREATE), self.idb.keys())
            return defer.DeferredList(dlist, fireOnOneErrback = True)
        
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
        
        self.initd.addCallback(open_pdb)
        self.initd.addCallback(set_idb_flags)
        self.initd.addCallback(open_idb)
        self.initd.addCallback(associate)
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
                                if not success:
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
            
            def get_fields((identity, indexes, required, optional)):
                fields = dict(required.items() + optional.items())
                return defer.succeed((identity, fields))
                
            def put_instance((identity, fields)):
                data = pickle.dumps(fields)
                return self.pdb.put(identity, data)
                
            def complete(results):
                return defer.succeed(instance)
                
            d = defer.Deferred()
            
            d.addCallback(get_fields)
            d.addCallback(put_instance)
            d.addCallback(complete)
            
            reactor.callLater(0, d.callback, (identity, indexes, required, optional))
            return d
            
        def complete(result):
            return defer.succeed(instance)
            
        d = defer.Deferred()
        
        d.addCallback(self.init)    
        d.addCallback(unpack)
        d.addCallback(put)
        d.addCallback(complete)
            
        reactor.callLater(0, d.callback, instance)
        return d
    
    def remove(self, instance):
        
        def unpack_identity(_):
            return self.unpacker.unpack_identity(instance)
        
        def check_exists(identity):
            
            def complete(result):
                if result:
                    return defer.succeed(identity)
                return defer.fail(AttributeError("Entity not exists: %s" % identity))
            
            d = self.pdb.exists(identity)
            d.addCallback(complete)
            return d
        
        def remove_from_cache(identity):
            if self.id_cache.has_key(identity):
                del self.id_cache[identity]
            return defer.succeed(identity)
        
        def remove_from_pdb(identity):
            return self.pdb.delete(identity)
        
        def complete(_):
            return defer.succeed(True)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(unpack_identity)
        d.addCallback(check_exists)
        d.addCallback(remove_from_cache)
        d.addCallback(remove_from_pdb)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def get(self, identity):
        
        def check_exists(_):
            
            def complete(result):
                if result:
                    return defer.succeed(identity)
                return defer.fail(AttributeError("Entity not exists: %s" % identity))
            
            d = self.pdb.exists(identity)
            d.addCallback(complete)
            return d
        
        def get(identity):
            
            if self.id_cache.has_key(identity):
                return defer.succeed((self.id_cache[identity], identity))
            
            def unpack_fields(identity):
                
                def fetch(identity):
    
                    def complete(data):
                        items = pickle.loads(data)
                        return defer.succeed((identity, items))
                    
                    d = self.pdb.get(identity)
                    d.addCallback(complete)
                    return d
                
                def complete((identity, items)):
                
                    fields = {}
                    toFetch = {}
        
                    for (name, value) in items.items():
                        if self.fields_storages.has_key(name):
                            fields[name] = None
                            toFetch[name] = value
                        else:
                            fields[name] = value
                        
                    return defer.succeed((identity, fields, toFetch))
                
                d = defer.Deferred()
                d.addCallback(fetch)
                d.addCallback(complete)
                
                reactor.callLater(0, d.callback, identity)
                return d
                
            
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
        
        reactor.callLater(0, d.callback, identity)
        return d
    
    def where(self, **kwargs):
        
        def calc_index(_):
            return defer.succeed((kwargs.keys()[0], kwargs[kwargs.keys()[0]]))
        
        def get((index, value)):
            
            if Entity.providedBy(value):
                value = value.id
            
            if self.idb.has_key(index):
                
                def get_cursor(_):
                    return self.idb[index].cursor()
                
                def fetch(cursor):
                    
                    ids = []
                    
                    def set_key(_):
                        
                        def complete(result):
                            
                            if result is None:
                                return defer.succeed(False)
                            
                            if result[0] == pickle.dumps(value):
                                ids.append(result[1])
                                return defer.succeed(True)
                            
                            return defer.succeed(False)
                    
                        d = cursor.pget_(pickle.dumps(value), db.DB_SET_RANGE)
                        d.addCallback(complete)
                        return d
                    
                    def fetch_next(result):
                        
                        if not result:
                            return defer.succeed(True)
                        
                        def complete(result):
                            if result is not None:
                                ids.append(result[1])
                                return fetch_next(True)
                            return defer.succeed(True)
                        
                        d = cursor.pget_(pickle.dumps(value), db.DB_NEXT_DUP)
                        d.addCallback(complete)
                        return d
                    
                    def complete(_):
                        return defer.succeed((cursor, ids))
                    
                    d = defer.Deferred()
                    
                    d.addCallback(set_key)
                    d.addCallback(fetch_next)
                    d.addCallback(complete)
                    
                    reactor.callLater(0, d.callback, None)
                    return d
                
                def close_cursor((cursor, identities)):
                    
                    def complete(_):
                        return defer.succeed(identities)
                    
                    d = cursor.close()
                    d.addCallback(complete)
                    return d
                
                d = defer.Deferred()
                
                d.addCallback(get_cursor)
                d.addCallback(fetch)
                d.addCallback(close_cursor)
                
                reactor.callLater(0, d.callback, None)
                return d
                
            return defer.succeed([])
        
        def complete(identities):
            return defer.succeed(identities)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(calc_index)
        d.addCallback(get)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, kwargs)
        return d