from zope.interface import implements
from twisted.internet import defer, reactor
from twisted.python import components

import interface
import service

from yogomee.core import entity
from yogomee.core import storage

from yogomee.entity import user
from yogomee.entity import invitation

import simplejson as json

class InvitationService(object):
    
    implements(interface.IInvitationService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = storage.interface.IStorageFactory(self.service.storageFactory)
        
    def accept_invitation(self, id):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def reject_invitation(self, id):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def add_invitation(self, cre, own, data):
        
        def create(_):
            return invFactory.create(creator = cre, owner = own, status = 2, type = 1, text = "")
        
        def add(result):
            return invRepository.add(result)
        
        def persist(result):
            
            def complete(_):
                return defer.succeed(result)
            
            d = invRepository.persist()
            d.addCallback(complete)
            return d
        
        invFactory = entity.factory.Factory(invitation.Invitation)
        invRepository = entity.repository.Repository(invitation.Invitation, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(create)
        d.addCallback(add)
        d.addCallback(persist)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def get_invitation(self, id):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def save_invitation(self, id, data):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def delete_invitation(self, id):
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def get_invitations(self,
                        user,
                        accepted,
                        rejected,
                        waiting,
                        sent,
                        received,
                        targets,
                        friends):
        
        def get(_):
            if(sent):
                return invRepository.where(creator = user)
            else:
                return invRepository.where(owner = user)
        
        invRepository = entity.repository.Repository(invitation.Invitation, self.storageFactory)
        
        d = defer.Deferred()
        d.addCallback(get)
        reactor.callLater(0, d.callback, None)
        return d
    
components.registerAdapter(
                           InvitationService,
                           service.Service,
                           interface.IInvitationService)