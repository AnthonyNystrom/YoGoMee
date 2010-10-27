from twisted.web import server
from twisted.web.resource import Resource
from twisted.internet import defer
from zope.interface import implements

import simplejson as json

from yogomee.service.interface import IService, IAuthService, IUserService
from yogomee.service.auth import AuthService
from yogomee.service.user import UserService

import resource
import interface
import time

class ResourceBase(Resource):
    
    implements(interface.IResource)
    
    def __init__(self, service):
        Resource.__init__(self)
        self.service = IService(service)
        
    def render(self, request):
        self.time = time.time()
        d = self.get_response(request)
        d.addCallback(self.make_response)
        d.addCallback(self.encode_response)
        d.addCallback(self.write_encoded_response, request)
        d.addErrback(self.write_fail, request)
        return server.NOT_DONE_YET
    
    def get_response(self, request):
        m_get_response = getattr(self, 'get_response_' + request.method, None)
        if not m_get_response:
            return defer.fail(Exception("Unsupported method"))
        return m_get_response(request)
    
    def make_response(self, data):
        response = {}
        response["status"] = "OK"
        response["data"] = data
        response["time"] = time.time() - self.time
        return defer.succeed(response)
    
    def encode_response(self, response):
        try:
            return defer.succeed(json.dumps(response))
        except Exception, e:
            return defer.fail(Exception("Internal server error"))
    
    def write_encoded_response(self, encoded_response, request):
        request.write(encoded_response)
        request.finish()
    
    def write_fail(self, fail, request):
        response = {}
        response["status"] = "FAIL"
        response["error"] = fail.value.message
        response["time"] = time.time() - self.time
        request.write(json.dumps(response))
        request.finish()
        
class AuthResource(resource.ResourceBase):
    
    implements(interface.IAuthResource)
    
    def __init__(self, service):
        resource.ResourceBase.__init__(self, service)
        self.auth_service = IAuthService(service)
        
    def get_response(self, request):
        d = self.auth_user(request)
        d.addCallback(self.check_and_auth, request)
        return d
    
    def check_and_auth(self, authUser, request):
        d = self.check(authUser, request)
        d.addCallback(self.checked, authUser, request)
        return d
    
    def check(self, authUser, request):
        m_check = getattr(self, "check_" + request.method, None)
        if not m_check:
            return defer.succeed(True)
        return m_check(authUser, request)
    
    def checked(self, result, authUser, request):
        if result:
            return self.auth(authUser, request)
        return defer.fail(Exception("Access denied"))
    
    def auth(self, authUser, request):
        m_auth = getattr(self, "auth_" + request.method, None)
        if not m_auth:
            return defer.fail(Exception("Unsupported method"))
        return m_auth(authUser, request)
    
    def auth_user(self, request):
        return self.auth_service.auth_user(request)
    
class UserResourceBase(AuthResource):
    
    implements(interface.IUserResourceBase)
    
    def __init__(self, identity, service):
        AuthResource.__init__(self, service)
        self.user_service = IUserService(service)
        self.identity = identity
    
    def check(self, authUser, request):
        d = self.get_user(authUser, request)
        d.addCallback(lambda user: self.user_check(authUser, user, request))
        return d
        
    def user_check(self, authUser, user, request):
        m_user_check = getattr(self, "user_check_" + request.method, None)
        if not m_user_check:
            return defer.succeed(True)
        return m_user_check(authUser, user, request)
        
    def auth(self, authUser, request):
        d = self.get_user(authUser, request)
        d.addCallback(lambda user: self.user_auth(authUser, user, request))
        return d
    
    def user_auth(self, authUser, user, request):
        m_user_auth = getattr(self, "user_auth_" + request.method, None)
        if not m_user_auth:
            return defer.fail(Exception("Unsupported method"))
        return m_user_auth(authUser, user, request)
    
    def get_user(self, authUser, request):
        if self.identity is None:
            return defer.succeed(authUser)
        return self.user_service.get_user(self.identity)