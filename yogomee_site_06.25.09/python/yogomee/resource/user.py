from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.service.interface import IUserService, IUserProfileService, IGomeeService
from yogomee.service.user import UserService, UserProfileService
from yogomee.service.gomee import GomeeService

from resource import AuthResource, UserResourceBase

import interface
import simplejson as json
import base64

class UsersResource(AuthResource):
    
    implements(interface.IUsersResource)
    
    def __init__(self, service):
        AuthResource.__init__(self, service)
        self.user_service = IUserService(service)
        
    def getChild(self, path, request):
        return UserResource(path, self.service)
    
    def check_POST(self, authUser, request):
        return defer.succeed(authUser.login == "root")
    
    def auth_POST(self, authUser, request):
        
        def add_user(_):
            user = json.loads(request.content.read())
            login = user["login"]
            secret = user["secret"]
            return self.user_service.add_user(login, secret)
            
        def complete(user):
            return defer.succeed({"id" : user.id, "login" : user.login})
        
        d = defer.Deferred()
        
        d.addCallback(add_user)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def check_GET(self, authUser, request):
        return defer.succeed(True)
    
    def auth_GET(self, authUser, request):
        
        def get_users(_):
            lat1 = float(request.args["lat1"][0])
            lat2 = float(request.args["lat2"][0])
            lng1 = float(request.args["lng1"][0])
            lng2 = float(request.args["lng2"][0])
            return self.user_service.get_users(lat1, lng1, lat2, lng2)
        
        def complete(results):
            return defer.succeed(map(lambda u: {"id" : u.id, "login" : u.login}, results))
        
        d = defer.Deferred()
        
        d.addCallback(get_users)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
class UserResource(UserResourceBase):
    
    implements(interface.IUserResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.putChild("profile", UserProfileResource(identity, service))
        self.putChild("messages", MessagesResource(identity, service))
        self.putChild("gomees", GomeesResource(identity, service))
        self.putChild("friends", FriendsResource(identity, service))
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(True)
    
    def user_auth_GET(self, authUser, user, request):
        return defer.succeed({"id" : user.id, "login" : user.login})
    
    def user_check_DELETE(self, authUser, user, request):
        return defer.succeed(authUser.login == "root")
    
    def user_auth_DELETE(self, authUser, user, request):
        return self.user_service.del_user(user)
    
class UserProfileResource(UserResourceBase):
    
    implements(interface.IUserProfileResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.profileService = IUserProfileService(service)
        self.gomeeService = IGomeeService(service)
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.login != "root")
    
    def user_auth_GET(self, authUser, user, request):
        
        def get_profile(user):
            return self.profileService.get_user_profile(user)
        
        def get_profile_gomees(profile):
            
            def complete(gomees):
                return defer.succeed((profile, gomees))
            
            return self.gomeeService.get_profile_gomees(user).addCallback(complete)
            
        def complete((profile, gomees)):
            return defer.succeed({
                                  "id" : profile.id,
                                  "firstName" : profile.firstName,
                                  "lastName" : profile.lastName,
                                  "email" : profile.email,
                                  "gomees" : map(lambda gm: {
                                                            "id" : gm.id,
                                                            "owner" : gm.owner.id,
                                                            "lat" : gm.lat,
                                                            "lng" : gm.lng,
                                                            "caption" : gm.caption,
                                                            "address" : gm.address,
                                                            "description" : gm.description,
                                                            "type" : gm.type
                                                            }, gomees)
                                  })
        
        d = defer.Deferred()
        
        d.addCallback(get_profile)
        d.addCallback(get_profile_gomees)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, user)
        return d
    
    def user_check_PUT(self, authUser, user, request):
        return defer.succeed(authUser.login != "root" and authUser.id == user.id)
    
    def user_auth_PUT(self, authUser, user, request):
        
        def update_profile(_):
            profile = json.loads(request.content.read())
            return self.profileService.update_user_profile(user, profile)
            
        def complete(profile):
            return defer.succeed({
                                  "id" : profile.id,
                                  "firstName" : profile.firstName,
                                  "lastName" : profile.lastName,
                                  "email" : profile.email
                                  })
        
        d = defer.Deferred()
        
        d.addCallback(update_profile)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
from message import MessagesResource
from gomee import GomeesResource
from friend import FriendsResource