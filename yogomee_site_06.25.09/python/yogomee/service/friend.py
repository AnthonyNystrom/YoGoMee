from zope.interface import implements
from twisted.internet import defer, reactor
from twisted.python import components

import interface
import service

from yogomee.core import entity
from yogomee.core import storage

from yogomee.entity import user
from yogomee.entity import friend

class FriendService(object):
    
    implements(interface.IFriendService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = storage.interface.IStorageFactory(self.service.storageFactory)
        self.friendFactory = entity.factory.Factory(friend.Friend)
        self.friendRepository = entity.repository.Repository(friend.Friend, self.storageFactory)
        
    def get_friends(self, user):
        
        def complete(results):
            user1 = results[0][1]
            user2 = results[1][1]
            user1 = map(lambda f: f.user2, user1)
            user2 = map(lambda f: f.user1, user2)
            return defer.succeed(user1 + user2)
        
        d = defer.DeferredList([
                                self.friendRepository.where(user1 = user),
                                self.friendRepository.where(user2 = user)
                                ])
        d.addCallback(complete)
        return d
    
components.registerAdapter(
                           FriendService,
                           service.Service,
                           interface.IFriendService)