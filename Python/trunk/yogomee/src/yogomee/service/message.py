from zope.interface import implements
from twisted.internet import defer, reactor
from twisted.python import components

import interface
import service

from yogomee.core import entity
from yogomee.core import storage

from yogomee.entity import user
from yogomee.entity import message

class MessageService(object):
    
    implements(interface.IMessageService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = storage.interface.IStorageFactory(self.service.storageFactory)
        self.messageFactory = entity.factory.Factory(message.Message)
        self.messageRepository = entity.repository.Repository(message.Message, self.storageFactory)
    
    def add_message(self, fromUsr, toUsr, message):
        
        def create_user(_):
            return self.msgFactory.create(fromUser = fromUsr, toUser = toUsr, msg = message, status = "new")
        
        def add_user(msg):
            return msgRepository.add(msg)
        
        def persist_msg(msg):
            
            def complete(_):
                return defer.succeed(msg)
            
            d = msgRepository.persist()
            d.addCallback(complete)
            return d
        
        def complete(msg):
            return defer.succeed(msg)
        
        msgRepository = entity.repository.Repository(message.Message, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(create_msg)
        d.addCallback(add_msg)
        d.addCallback(persist_msg)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
        
    def get_message(self, identity):
        return self.messageRepository.get(identity)
    
    def get_messages(self, user):
        
        def complete(results):
            sent = results[0][1]
            recv = results[1][1]
            return defer.succeed(sent + recv)
        
        d = defer.DeferredList([
                                self.get_sent_messages(user),
                                self.get_received_messages(user)
                                ], consumeErrors = True)
        d.addCallback(complete)
        return d
    
    def get_sent_messages(self, user):
        return self.messageRepository.where(fromUser = user)
    
    def get_received_messages(self, user):
        return self.messageRepository.where(toUser = user)
    
components.registerAdapter(
                           MessageService,
                           service.Service,
                           interface.IMessageService)