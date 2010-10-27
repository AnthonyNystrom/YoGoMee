from zope.interface import implements
from twisted.internet import defer, reactor
from twisted.python import components

import interface
import service

from yogomee.core import entity
from yogomee.core import storage

from yogomee.entity import user
from yogomee.entity import gomee

class GomeeService(object):
    
    implements(interface.IGomeeService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = storage.interface.IStorageFactory(self.service.storageFactory)
        self.gomeeFactory = entity.factory.Factory(gomee.Gomee)
        self.gomeeRepository = entity.repository.Repository(gomee.Gomee, self.storageFactory)
    
    def add_gomee(self, own, lt, lg, capt, addr, desc, typ):
        
        def create_gomee(_):
            return self.gomeeFactory.create(owner = own, lat = lt, lng = lg, caption = capt, address = addr, description = desc, type = typ)
        
        def add_gomee(gomee):
            return gomeeRepository.add(gomee)
        
        def persist_gomee(gomee):
            
            def complete(_):
                return defer.succeed(gomee)
            
            d = gomeeRepository.persist()
            d.addCallback(complete)
            return d
        
        def complete(gomee):
            return defer.succeed(gomee)
        
        gomeeRepository = entity.repository.Repository(gomee.Gomee, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(create_gomee)
        d.addCallback(add_gomee)
        d.addCallback(persist_gomee)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def save_gomee(self, identity, lt, lg, capt, addr, desc, typ):
        
        def get_gomee(_):
            return gomeeRepository.get(identity)
        
        def update_gomee(gm):
            gm.lat = lt
            gm.lng = lg
            gm.caption = capt
            gm.address = addr
            gm.description = desc
            gm.type = typ
            return defer.succeed(gm)
            
        def persist_gomee(gm):
            
            def complete(_):
                return defer.succeed(gm)
            
            d = gomeeRepository.persist()
            d.addCallback(complete)
            return d
        
        def complete(gm):
            return defer.succeed(gm)
        
        gomeeRepository = entity.repository.Repository(gomee.Gomee, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(get_gomee)
        d.addCallback(update_gomee)
        d.addCallback(persist_gomee)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
        
    def get_gomee(self, identity):
        gomeeRepository = entity.repository.Repository(gomee.Gomee, self.storageFactory)
        
        return gomeeRepository.get(identity)
    
    def del_gomee(self, identity):
        
        def get_gomee(_):
            return gomeeRepository.get(identity)
        
        def remove_gomee(instance):
            return gomeeRepository.remove(instance)
        
        def persist(_):
            return gomeeRepository.persist()
        
        def complete(_):
            return defer.succeed(True)
        
        gomeeRepository = entity.repository.Repository(gomee.Gomee, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(get_gomee)
        d.addCallback(remove_gomee)
        d.addCallback(persist)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
        
    
    def get_gomees(self, user, lat1, lng1, lat2, lng2):
        
        def filter_results(results):
            
            def filter_func(gm):
                if (gm.lat <= lat1) and \
                    (gm.lat >= lat2) and \
                    (gm.lng >= lng1) and \
                    (gm.lng <= lng2):
                    return True
                
                return False
            
            return defer.succeed(filter(filter_func, results))
        
        gomeeRepository = entity.repository.Repository(gomee.Gomee, self.storageFactory)
        
        return gomeeRepository.where(owner = user).addCallback(filter_results)
    
    def get_profile_gomees(self, user):
        
        def get_gomees(_):
            return gomeeRepository.where(owner = user)
        
        def get_profile_gomees(gomees):
            return defer.succeed(filter(lambda gm: gm.type == 0, gomees))
        
        gomeeRepository = entity.repository.Repository(gomee.Gomee, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(get_gomees)
        d.addCallback(get_profile_gomees)
        
        reactor.callLater(0, d.callback, None)
        return d
    
components.registerAdapter(
                           GomeeService,
                           service.Service,
                           interface.IGomeeService)