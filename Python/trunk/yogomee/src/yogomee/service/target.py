from zope.interface import implements
from twisted.internet import defer, reactor
from twisted.python import components

import interface
import service

from yogomee.core import entity
from yogomee.core import storage

from yogomee.entity import user
from yogomee.entity import gomee
from yogomee.entity import target

class TargetService(object):
    
    implements(interface.ITargetService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = storage.interface.IStorageFactory(self.service.storageFactory)
        self.targetFactory = entity.factory.Factory(target.Target)
        
    def add_target(self, owner, creator, gomee, data):
        
        def create_target(_):
            return self.targetFactory.create(owner = owner)
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def save_target(self, id, data):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def del_target(self, id):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def get_target(self, id):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def get_targets(self, user):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
components.registerAdapter(
                           TargetService,
                           service.Service,
                           interface.ITargetService)