from zope.interface import implements
from twisted.internet import defer, reactor
from twisted.python import components

import interface
import service

from yogomee.core.entity import repository
from yogomee.core.entity import factory
from yogomee.core.storage.interface import IStorageFactory
from yogomee.entity.user import User

import urllib
import hmac
import hashlib
import base64
import string

class AuthService(object):
    
    implements(interface.IAuthService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = IStorageFactory(self.service.storageFactory)
        self.userFactory = factory.Factory(User) 
        
        self.initialized = False
        self.initd = None
    
    def init(self, *args):
        
        if self.initialized:
            return defer.succeed(True)
        
        if self.initd is not None:
            return self.initd
        
        def create_root(_):
            
            def complete(user):
                self.root = user
                return defer.succeed(True)
            
            d = self.userFactory.create(login = "root", secret = "root")
            d.addCallback(complete)
            return d
        
        def complete(_):
            self.initialized = True
            return defer.succeed(True)
        
        self.initd = defer.Deferred()
        
        self.initd.addCallback(create_root)
        self.initd.addCallback(complete)
        
        reactor.callLater(0, self.initd.callback, None)
        return self.initd
        
    def auth_user(self, request):
        
        def get_login(_):
            
            arg_exists = map(lambda arg: request.args.has_key(arg), ("oauth_consumer_key",
                                                                     "oauth_timestamp",
                                                                     "oauth_nonce",
                                                                     "oauth_signature"))
            
            if len(filter(lambda exists: not exists, arg_exists)):
                return defer.fail(Exception("Unauthorized."))
            
            return defer.succeed((request.args["oauth_consumer_key"][0],
                                  request.args["oauth_timestamp"][0],
                                  request.args["oauth_nonce"][0],
                                  request.args["oauth_signature"][0]))
        
        def fetch_user((consumer_key, timestamp, nonce, signature)):
            
            if consumer_key == "root":
                return defer.succeed((self.root,
                                      timestamp,
                                      nonce,
                                      signature))
            
            def complete(results):
                
                if not len(results):
                    return defer.fail(Exception("Unauthorized."))
                
                return defer.succeed((results[0],
                                      timestamp,
                                      nonce,
                                      signature))
            
            d = userRepository.where(login = consumer_key)
            d.addCallback(complete)
            return d
        
        def sign_request((user, timestamp, nonce, signature)):
            
            def make_base_string(_):
                
                method = urllib.quote(string.upper(request.method), "")
                path = urllib.quote("http://yogomee.com" + string.lower(request.path), "")
                args = urllib.quote(urllib.urlencode({"oauth_consumer_key" : user.login,
                                                      "oauth_timestamp" : timestamp,
                                                      "oauth_nonce" : nonce}), "")
                return defer.succeed("%s&%s&%s" % (method, path, args))
            
            def sign(base_string):
                hashed = hmac.new("%s&" % user.secret, base_string, hashlib.sha1)
                return defer.succeed(base64.standard_b64encode(hashed.digest()))
            
            def check(sig):
                if sig == signature:
                    return defer.succeed(True)
                return defer.fail(Exception("Unauthorized."))
            
            def complete(_):
                return defer.succeed(user)
            
            d = defer.Deferred()
            
            d.addCallback(make_base_string)
            d.addCallback(sign)
            d.addCallback(check)
            d.addCallback(complete)
            
            reactor.callLater(0, d.callback, None)
            return d
        
        def complete(user):
            return defer.succeed(user)
        
        userRepository = repository.Repository(User, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(self.init)
        d.addCallback(get_login)
        d.addCallback(fetch_user)
        d.addCallback(sign_request)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, request)
        return d
    
components.registerAdapter(AuthService, service.Service, interface.IAuthService)