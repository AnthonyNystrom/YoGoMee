from zope.interface import implements
from twisted.internet import defer, reactor
from twisted.python import components

import interface
import service

from yogomee.core import entity
from yogomee.core import storage
from yogomee.entity import user
from yogomee.entity import gomee

class UserService(object):
    
    implements(interface.IUserService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = storage.interface.IStorageFactory(self.service.storageFactory)
        self.userFactory = entity.factory.Factory(user.User)
        self.profileFactory = entity.factory.Factory(user.UserProfile)
    
    def get_user(self, id):
        userRepository = entity.repository.Repository(user.User, self.storageFactory)
        return userRepository.get(id)
        
    def add_user(self, userLogin, userSecret):

        def check_exists(_):
            
            def complete(result):
                if len(result):
                    return defer.fail(AttributeError("User already exists: %s" % userLogin))
                return defer.succeed(True)
            
            d = userRepository.where(login = str(userLogin))
            d.addCallback(complete)
            return d
        
        def create_user(_):
            return self.userFactory.create(login = str(userLogin), secret = str(userSecret))
        
        def add_user(user):
            return userRepository.add(user)
        
        def persist_user(user):
            
            def complete(_):
                return defer.succeed(user)
            
            d = userRepository.persist()
            d.addCallback(complete)
            return d
        
        def create_profile(usr):
            
            def complete(profile):
                return defer.succeed((usr, profile))
            
            d = self.profileFactory.create(
                                           user = usr,
                                           firstName = "",
                                           lastName = "",
                                           email = "",
                                           twitterLogin = "",
                                           twitterSecret = "",
                                           twitterUpdateOnAddGomee = True,
                                           twitterUpdateOnSaveGomee = True,
                                           twitterUpdateOnDeleteGomee = False)
            d.addCallback(complete)
            return d
        
        def add_profile((user, profile)):
            
            def complete(_):
                return defer.succeed((user, profile))
            
            d = profileRepository.add(profile)
            d.addCallback(complete)
            return d
        
        def persist_profile((user, profile)):
            
            def complete(_):
                return defer.succeed((user, profile))
            
            d = profileRepository.persist()
            d.addCallback(complete)
            return d
        
        def complete((user, profile)):
            return defer.succeed(user)
        
        userRepository = entity.repository.Repository(user.User, self.storageFactory)
        profileRepository = entity.repository.Repository(user.UserProfile, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(check_exists)
        d.addCallback(create_user)
        d.addCallback(add_user)
        d.addCallback(persist_user)
        d.addCallback(create_profile)
        d.addCallback(add_profile)
        d.addCallback(persist_profile)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
        
    def del_user(self, user):
        userRepository = entity.repository.Repository(user.User, self.storageFactory)
        return userRepository.remove(user)
    
    def get_users(self, lat1, lng1, lat2, lng2):
        
        def get_profile_gomees(_):
            return gomeeRepository.where(type = 0)
        
        def filter_results(results):
            
            def filter_func(gm):
                if (gm.lat <= lat1) and \
                    (gm.lat >= lat2) and \
                    (gm.lng >= lng1) and \
                    (gm.lng <= lng2):
                    return True
                
                return False
            
            return defer.succeed(filter(filter_func, results))
        
        def get_users(results):
            return defer.succeed(map(lambda gm: gm.owner, results))
        
        userRepository = entity.repository.Repository(user.User, self.storageFactory)
        profileRepository = entity.repository.Repository(user.UserProfile, self.storageFactory)
        gomeeRepository = entity.repository.Repository(gomee.Gomee, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(get_profile_gomees)
        d.addCallback(filter_results)
        d.addCallback(get_users)
        
        reactor.callLater(0, d.callback, None)
        return d
    
components.registerAdapter(
                           UserService,
                           service.Service,
                           interface.IUserService)

class UserProfileService(object):
    
    implements(interface.IUserProfileService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = storage.interface.IStorageFactory(self.service.storageFactory)
        self.profileFactory = entity.factory.Factory(user.UserProfile)

        
    def get_user_profile(self, usr):
        
        def get_profile(_):
            return profileRepository.where(user = usr) 
        
        def complete(result):
            return defer.succeed(result[0])
        
        profileRepository = entity.repository.Repository(user.UserProfile, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(get_profile)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def update_user_profile(self, usr, usrProfile):
        
        def get_profile(_):
            
            def complete(result):
                return defer.succeed(result[0])
            
            d = profileRepository.where(user = usr)
            d.addCallback(complete)
            return d 
        
        def update_profile(profile):
            
            if usrProfile.has_key("firstName"):
                profile.firstName = str(usrProfile["firstName"])
            if usrProfile.has_key("lastName"):
                profile.lastName = str(usrProfile["lastName"])
            if usrProfile.has_key("email"):
                profile.email = str(usrProfile["email"])
            if usrProfile.has_key("twitterLogin"):
                profile.twitterLogin = str(usrProfile["twitterLogin"])
            if usrProfile.has_key("twitterSecret"):
                profile.twitterSecret = str(usrProfile["twitterSecret"])
            if usrProfile.has_key("twitterUpdateOnAddGomee"):
                profile.twitterUpdateOnAddGomee = usrProfile["twitterUpdateOnAddGomee"]
            if usrProfile.has_key("twitterUpdateOnSaveGomee"):
                profile.twitterUpdateOnSaveGomee = usrProfile["twitterUpdateOnSaveGomee"]
            if usrProfile.has_key("twitterUpdateOnDeleteGomee"):
                profile.twitterUpdateOnDeleteGomee = usrProfile["twitterUpdateOnDeleteGomee"]
            
            return defer.succeed(profile)
        
        def persist(profile):
            
            def complete(_):
                return defer.succeed(profile)
            
            d = profileRepository.persist()
            d.addCallback(complete)
            return d
        
        def complete(profile):
            return defer.succeed(profile)
        
        profileRepository = entity.repository.Repository(user.UserProfile, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(get_profile)
        d.addCallback(update_profile)
        d.addCallback(persist)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
components.registerAdapter(
                           UserProfileService,
                           service.Service,
                           interface.IUserProfileService)