from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.service.interface import IFriendService
from yogomee.service.friend import FriendService
from resource import UserResourceBase

import interface

class FriendsResource(UserResourceBase):
    
    implements(interface.IFriendsResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.friendService = IFriendService(service)
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(True)
    
    def user_auth_GET(self, authUser, user, request):
        
        def complete(friends):
            fs = map(lambda usr: {
                                  "id" : usr.id,
                                  "login" : usr.login
                                  }, friends)
            return defer.succeed(fs)
        
        d = self.friendService.get_friends(user)
        d.addCallback(complete)
        return d