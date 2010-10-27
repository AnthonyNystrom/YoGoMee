from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.service.interface import IGomeeService
from yogomee.service.gomee import GomeeService
from resource import UserResourceBase

import interface
import simplejson as json

class GomeesResource(UserResourceBase):
    
    implements(interface.IGomeesResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.gomeeService = IGomeeService(service)
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.login != "root")
    
    def user_auth_GET(self, authUser, user, request):
        
        def complete(gomees):
            gms = map(lambda gm: {
                                  "id" : gm.id,
                                  "owner" : gm.owner.id,
                                  "lat" : gm.lat,
                                  "lng" : gm.lng,
                                  "caption" : gm.caption,
                                  "address" : gm.address,
                                  "description" : gm.description,
                                  "type" : gm.type
                                  }, gomees)
            return defer.succeed(gms)
        
        lat1 = float(request.args["lat1"][0])
        lat2 = float(request.args["lat2"][0])
        lng1 = float(request.args["lng1"][0])
        lng2 = float(request.args["lng2"][0])
        
        d = self.gomeeService.get_gomees(user, lat1, lng1, lat2, lng2)
        d.addCallback(complete)
        return d
    
    def user_check_POST(self, authUser, user, request):
        return defer.succeed(authUser.id == user.id)
    
    def user_auth_POST(self, authUser, user, request):
        
        def add_gomee(_):
            gomee = json.loads(request.content.read())
            return self.gomeeService.add_gomee(user,
                                               gomee["lat"],
                                               gomee["lng"],
                                               str(gomee["caption"]),
                                               str(gomee["address"]),
                                               str(gomee["description"]),
                                               gomee["type"])
            
        def complete(gm):
            return defer.succeed({
                                  "id" : gm.id,
                                  "owner" : gm.owner.id,
                                  "lat" : gm.lat,
                                  "lng" : gm.lng,
                                  "caption" : gm.caption,
                                  "address" : gm.address,
                                  "description" : gm.description,
                                  "type" : gm.type
                                  })
        
        d = defer.Deferred()
        
        d.addCallback(add_gomee)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def getChild(self, path, request):
        return GomeeResource(self.identity, path, self.service)

class GomeeResource(UserResourceBase):
    
    implements(interface.IGomeeResource)
    
    def __init__(self, identity, gomeeIdentity, service):
        UserResourceBase.__init__(self, identity, service)
        self.gomeeService = IGomeeService(service)
        self.gomeeIdentity = gomeeIdentity
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(True)
    
    def user_auth_GET(self, authUser, user, request):
        
        def complete(gm):
            return defer.succeed({
                                  "id" : gm.id,
                                  "owner" : gm.owner.id,
                                  "lat" : gm.lat,
                                  "lng" : gm.lng,
                                  "address" : gm.address,
                                  "description" : gm.description,
                                  "type" : gm.type
                                  })
        
        d = self.gomeeService.get_gomee(self.gomeeIdentity)
        d.addCallback(complete)
        return d
    
    def user_check_PUT(self, authUser, user, request):
        return defer.succeed(authUser.id == user.id)
    
    def user_auth_PUT(self, authUser, user, request):
        
        def save_gomee(_):
            gomee = json.loads(request.content.read())
            return self.gomeeService.save_gomee(self.gomeeIdentity,
                                               gomee["lat"],
                                               gomee["lng"],
                                               str(gomee["caption"]),
                                               str(gomee["address"]),
                                               str(gomee["description"]),
                                               gomee["type"])
        
        def complete(gm):
            return defer.succeed({
                                  "id" : gm.id,
                                  "owner" : gm.owner.id,
                                  "lat" : gm.lat,
                                  "lng" : gm.lng,
                                  "address" : gm.address,
                                  "description" : gm.description,
                                  "type" : gm.type
                                  })
            
        d = defer.Deferred()
        
        d.addCallback(save_gomee)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def user_check_DELETE(self, authUser, user, request):
        return defer.succeed(authUser.id == user.id)
    
    def user_auth_DELETE(self, authUser, user, request):
        
        def del_gomee(_):
            return self.gomeeService.del_gomee(self.gomeeIdentity)
        
        d = defer.Deferred()
        
        d.addCallback(del_gomee)
        
        reactor.callLater(0, d.callback, None)
        return d