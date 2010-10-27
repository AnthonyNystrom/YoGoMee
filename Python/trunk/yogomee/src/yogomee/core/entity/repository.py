from zope.interface import implements
from twisted.internet import defer, reactor

import interface
from  yogomee.core import storage
import uuid

class Repository(object):
    
    implements(interface.IRepository)
    
    def __init__(self, entity, storageFactory):
        self.entity = interface.IEntity(entity)
        self.storageFactory = storage.interface.IStorageFactory(storageFactory)
        
        self.cache = {}
        
        self.new = {}
        self.dirty = {}
        self.deleted = {}
        
        self.initialized = False
        self.initd = None 
    
    def init(self, *args):
        
        if self.initialized:
            return defer.succeed(True)
        
        if self.initd is not None:
            return self.initd
        
        def get_storage(_):
            
            def complete(storage):
                self.storage = storage
                return defer.succeed(storage)
            
            d = self.storageFactory.get(self.entity)
            d.addCallback(complete)
            return d
        
        def complete(_):
            self.initialized = True
            return defer.succeed(True)
        
        self.initd = defer.Deferred()
        
        self.initd.addCallback(get_storage)
        self.initd.addCallback(complete)
        
        reactor.callLater(0, self.initd.callback, None)
        return self.initd
    
    def enhance_setter(self, setter):
        def new(entity, name, value):
            self.dirty[entity] = True
            setter(entity, name, value)
        return new
    
    def add(self, instance):
        #entity.__class__.__setattr__ = self.enhance_setter(entity.__class__.__setattr__)
        
        def set_id(_):
            identity = str(uuid.uuid4()).replace("-","")
            setattr(instance, self.entity.identity().name, identity)
            return defer.succeed((identity, instance))
        
        def add_to_cache((identity, instance)):
            self.cache[identity] = instance
            return defer.succeed((identity, instance))
        
        def add_to_new((identity, instance)):
            self.new[identity] = instance
            return defer.succeed(instance)
        
        def complete(instance):
            return defer.succeed(instance)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(set_id)
        d.addCallback(add_to_cache)
        d.addCallback(add_to_new)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, instance)
        return d
    
    def get(self, identity):
        
        def get(_):
            
            if self.cache.has_key(identity):
                return defer.succeed(self.cache[identity])
            
            def add_to_cache(instance):
                self.cache[identity] = instance
                return defer.succeed(instance)
            
            return self.storage.get(identity).addCallback(add_to_cache)
        
        def complete(instance):
            return defer.succeed(instance)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(get)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, identity)
        return d
    
    def persist(self):
        
        def put_new(_):
            dlist = map(lambda instance: self.storage.put(instance), self.new.values())
            d = defer.DeferredList(dlist, fireOnOneErrback = True)
            return d
        
        def remove_deleted(_):
            dlist = map(lambda instance: self.storage.remove(instance), self.deleted.values())
            d = defer.DeferredList(dlist, fireOnOneErrback = True)
            return d
        
        def put_cached(_):
            dlist = map(lambda instance: self.storage.put(instance), self.cache.values())
            d = defer.DeferredList(dlist, fireOnOneErrback = True)
            return d
        
        def complete(_):
            return defer.succeed(None)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(put_new)
        d.addCallback(remove_deleted)
        d.addCallback(put_cached)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def remove(self, entity):
        
        def check_exists(_):
            identity = getattr(entity, self.entity.identity().name)
            if self.cache.has_key(identity):
                return defer.succeed(identity)
            return defer.fail(AttributeError("Entity not exists: %s" % identity))
        
        def remove_from_cache(identity):
            del self.cache[identity]
            if self.new.has_key(identity):
                del self.new[identity]
            return defer.succeed(identity)
        
        def add_to_deleted(identity):
            self.deleted[identity] = entity
        
        def complete(_):
            return defer.succeed(True)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(check_exists)
        d.addCallback(remove_from_cache)
        d.addCallback(add_to_deleted)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def where(self, **kwargs):
        
        def get_ids(_):
            
            def get_cached(kwargs):
                field = kwargs.keys()[0]
                value = kwargs[kwargs.keys()[0]]
                items = filter(lambda (key, instance): value == getattr(instance, field), self.cache.items())
                return defer.succeed(map(lambda (key, instance): key, items))
            
            def get_stored(kwargs):
                return self.storage.where(**kwargs)
            
            def complete(results):
                cached = results[0][1]
                stored = results[1][1]
                cached = filter(lambda id: id not in stored, cached)
                return defer.succeed(cached + stored)
            
            d = defer.DeferredList([get_cached(kwargs), get_stored(kwargs)], fireOnOneErrback = True)
            d.addCallback(complete)
            return d
        
        def fetch(identities):
            
            def complete(results):
                return defer.succeed(map(lambda (success, result): result, results))
            
            dlist = map(lambda id: self.get(id), identities)
            d = defer.DeferredList(dlist, fireOnOneErrback = True)
            d.addCallback(complete)
            return d
        
        def complete(instances):
            return defer.succeed(instances)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(get_ids)
        d.addCallback(fetch)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, kwargs)
        return d