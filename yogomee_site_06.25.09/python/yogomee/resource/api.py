from twisted.internet import defer, reactor
from twisted.web import resource

from resource import AuthResource

import user

class ApiResource(AuthResource):
    
    def __init__(self, service):
        AuthResource.__init__(self, service)
        self.putChild("me", user.UserResource(None, service))
        self.putChild("users", user.UsersResource(service))