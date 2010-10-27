from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.service.interface import ITargetService, IGomeeService
from yogomee.service.target import TargetService
from yogomee.service.gomee import GomeeService

from resource import UserResourceBase

import interface
import simplejson as json

class TargetsResource(UserResourceBase):
    
    implements(interface.ITargetsResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.targetService = ITargetService(service)
        self.gomeeService = IGomeeService(service)
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.login != "root")
    
    def user_auth_GET(self, authUser, user, request):
        return self.targetService.get_targets(user)
    
    def user_check_POST(self, authUser, user, request):
        return defer.succeed(authUser.login != "guest" and authUser.id == user.id)
    
    def user_auth_POST(self, authUser, user, request):
        
        def get_gomee(_):
            return self.gomeeService.get_gomee(data["gomee"])
        
        def add_target(gm):
            return self.targetService.add_target(user, user, gm, data)
        
        def complete(result):
            return defer.succeed({
                                  "id" : result.id,
                                  "owner" : result.owner.id,
                                  "creator" : result.creator.id,
                                  "gomee" : result.gomee.id,
                                  "type" : result.type,
                                  "text" : result.text
                                  })
        
        data = json.loads(request.content.read())
        
        d = defer.Deferred()
        
        d.addCallback(get_gomee)
        d.addCallback(add_target)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def getChild(self, path, request):
        return TargetResource(self.identity, path, self.service)
    
    
class TargetResource(UserResourceBase):
    
    implements(interface.ITargetResource)
    
    def __init__(self, identity, targetIdentity, service):
        UserResourceBase.__init__(self, identity, service)
        self.targetService = ITargetService(service)
        self.targetIdentity = targetIdentity
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(True)
    
    def user_auth_GET(self, authUser, user, request):
        
        def get_target(_):
            return self.targetService.get_target(self.targetIdentity)
        
        def complete(result):
            return defer.succeed({
                                  "id" : result.id,
                                  "owner" : result.owner.id,
                                  "creator" : result.creator.id,
                                  "gomee" : result.gomee.id,
                                  "type" : result.type,
                                  "text" : result.text
                                  })
        
        d = defer.Deferred()
        
        d.addCallback(get_target)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def user_check_PUT(self, authUser, user, request):
        return defer.succeed(authUser.login != "guest" and authUser.id == user.id)
    
    def user_auth_PUT(self, authUser, user, request):
        
        def save_target(_):
            pass
        
        def complete(result):
            pass
        
        d = defer.Deferred()
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def user_check_DELETE(self, authUser, user, request):
        return defer.succeed(authUser.login != "guest" and authUser.id == user.id)
    
    def user_auth_DELETE(self, authUser, user, request):
        
        def delete_target(_):
            pass
        
        def complete(_):
            return defer.succeed(True)
        
        d = defer.Deferred()
        
        d.addCallback(delete_target)
        d.addCallback(complete)
        
        return d