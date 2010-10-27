from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.service.interface import IGomeeService, ITagService
from yogomee.service.gomee import GomeeService
from yogomee.service.tag import TagService

from resource import UserResourceBase

import interface
import simplejson as json

class GomeesResource(UserResourceBase):
    
    implements(interface.IGomeesResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.gomeeService = IGomeeService(service)
        self.tagService = ITagService(service)
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.login != "root")
    
    def user_auth_GET(self, authUser, user, request):
        
        def get_tags(gomees):
            
            def get_gomee_tags(gm):
                
                def complete(tags):
                    return defer.succeed({
                                  "id" : gm.id,
                                  "owner" : gm.owner.id,
                                  "lat" : gm.lat,
                                  "lng" : gm.lng,
                                  "caption" : gm.caption,
                                  "address" : gm.address,
                                  "description" : gm.description,
                                  "type" : gm.type,
                                  "common" : gm.common,
                                  "tags" : map(lambda t: t.tag.name, tags)
                                  })
                
                d = self.tagService.get_gomee_tags(gm)
                d.addCallback(complete)
                return d
            
            def complete(results):
                return defer.succeed(map(lambda (s, g): g, results))
            
            dlist = map(lambda g: get_gomee_tags(g), gomees)
            d = defer.DeferredList(dlist)
            d.addCallback(complete)
            return d
        
        def filter_tags(results):
            
            if(not request.args.has_key("tags")):
                return defer.succeed(results)
            
            tags = str(request.args["tags"][0]).split(",")
            
            def filter_func(result):
                
                present_tags = filter(lambda t: t in tags, result["tags"])
                
                if len(present_tags) > 0:
                    return True
                
                return False
            
            return defer.succeed(filter(lambda r: filter_func(r), results))
        
        lat1 = float(request.args["lat1"][0])
        lat2 = float(request.args["lat2"][0])
        lng1 = float(request.args["lng1"][0])
        lng2 = float(request.args["lng2"][0])
        
        d = self.gomeeService.get_gomees(user, lat1, lng1, lat2, lng2)
        d.addCallback(get_tags)
        d.addCallback(filter_tags)
        return d
    
    def user_check_POST(self, authUser, user, request):
        return defer.succeed(authUser.login != "guest" and authUser.id == user.id)
    
    def user_auth_POST(self, authUser, user, request):
        
        def add_gomee(_):
            return self.gomeeService.add_gomee(user,
                                               data["lat"],
                                               data["lng"],
                                               str(data["caption"]),
                                               str(data["address"]),
                                               str(data["description"]),
                                               data["type"],
                                               data["common"])
        
        def save_tags(gm):
            
            def complete(tags):
                return defer.succeed((gm, tags))
            
            d = self.tagService.set_gomee_tags(gm, data)
            d.addCallback(complete)
            return d
            
        def complete((gm, tags)):
            return defer.succeed({
                                  "id" : gm.id,
                                  "owner" : gm.owner.id,
                                  "lat" : gm.lat,
                                  "lng" : gm.lng,
                                  "caption" : gm.caption,
                                  "address" : gm.address,
                                  "description" : gm.description,
                                  "type" : gm.type,
                                  "common" : gm.common,
                                  "tags" : map(lambda t: t.tag.name, tags)
                                  })
        
        data = json.loads(request.content.read())
        
        d = defer.Deferred()
        
        d.addCallback(add_gomee)
        d.addCallback(save_tags)
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
        self.tagService = ITagService(service)
        self.gomeeIdentity = gomeeIdentity
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(True)
    
    def user_auth_GET(self, authUser, user, request):
        
        def get_tags(gm):
            
            def complete(tags):
                return defer.succeed((gm, tags))
            
            d = self.tagService.get_gomee_tags(gm)
            d.addCallback(complete)
            return d
        
        def complete((gm, tags)):
            return defer.succeed({
                                  "id" : gm.id,
                                  "owner" : gm.owner.id,
                                  "lat" : gm.lat,
                                  "lng" : gm.lng,
                                  "caption" : gm.caption,
                                  "address" : gm.address,
                                  "description" : gm.description,
                                  "type" : gm.type,
                                  "common" : gm.common,
                                  "tags": map(lambda t: t.tag.name, tags)
                                  })
        
        d = self.gomeeService.get_gomee(self.gomeeIdentity)
        d.addCallback(get_tags)
        d.addCallback(complete)
        return d
    
    def user_check_PUT(self, authUser, user, request):
        return defer.succeed(authUser.login != "guest" and authUser.id == user.id)
    
    def user_auth_PUT(self, authUser, user, request):
        
        def save_gomee(_):
            return self.gomeeService.save_gomee(self.gomeeIdentity, data)
        
        def save_tags(gm):
            
            def complete(tags):
                return defer.succeed((gm, tags))
            
            d = self.tagService.set_gomee_tags(gm, data)
            d.addCallback(complete)
            return d
            
        def complete((gm, tags)):
            return defer.succeed({
                                  "id" : gm.id,
                                  "owner" : gm.owner.id,
                                  "lat" : gm.lat,
                                  "lng" : gm.lng,
                                  "address" : gm.address,
                                  "description" : gm.description,
                                  "type" : gm.type,
                                  "common" : gm.common,
                                  "tags" : map(lambda t: t.tag.name, tags)
                                  })
        
        data = json.loads(request.content.read())
            
        d = defer.Deferred()
        
        d.addCallback(save_gomee)
        d.addCallback(save_tags)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def user_check_DELETE(self, authUser, user, request):
        return defer.succeed(authUser.login != "guest" and authUser.id == user.id)
    
    def user_auth_DELETE(self, authUser, user, request):
        
        def del_gomee(_):
            return self.gomeeService.del_gomee(self.gomeeIdentity)
        
        d = defer.Deferred()
        
        d.addCallback(del_gomee)
        
        reactor.callLater(0, d.callback, None)
        return d