from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.service.interface import IInvitationService
from yogomee.service.invitation import InvitationService

from resource import UserResourceBase

import interface
import simplejson as json

class InvitationsResource(UserResourceBase):
    
    implements(interface.IInvitationsResource)
    
    def __init__(self, identity, service,
                 accepted = False, rejected = False, waiting = False,
                 sent = False, received = False,
                 targets = False, friends = False):
        
        UserResourceBase.__init__(self, identity, service)
        self.invitationService = IInvitationService(service)
        self.accepted = accepted
        self.rejected = rejected
        self.waiting = waiting
        self.sent = sent
        self.received = received
        self.targets = targets
        self.friends = friends
        
        if(not self.accepted and not self.rejected and not self.waiting):
            self.putChild("accepted", InvitationsResource(identity, service, True, False, False, sent, received, targets, friends))
            self.putChild("rejected", InvitationsResource(identity, service, False, True, False, sent, received, targets, friends))
            self.putChild("waiting", InvitationsResource(identity, service, False, False, True, sent, received, targets, friends))
            
        if(not self.sent and not self.received):
            self.putChild("sent", InvitationsResource(identity, service, accepted, rejected, waiting, True, False, targets, friends))
            self.putChild("received", InvitationsResource(identity, service, accepted, rejected, waiting, False, True, targets, friends))
            
        if(not self.targets and not self.friends):
            self.putChild("targets", InvitationsResource(identity, service, accepted, rejected, waiting, sent, received, True, False))
            self.putChild("friends", InvitationsResource(identity, service, accepted, rejected, waiting, sent, received, False, True))
        
    def getChild(self, path, request):
        return InvitationResource(self.identity, path, self.service)
    
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.login != "root" and authUser.login != "guest" and authUser.id == user.id)
    
    def user_auth_GET(self, authUser, user, request):
        
        def get_invitations(_):
            return self.invitationService.get_invitations(user)
        
        def complete(results):
            return defer.succeed(map(lambda result: {
                                                     "id" : result.id,
                                                     "owner" : result.owner.id,
                                                     "creator" : result.creator.id,
                                                     "text" : result.text,
                                                     "type" : result.type,
                                                     "status" : result.status
                                                     }, results))
        
        d = defer.Deferred()
        
        d.addCallback(get_invitations)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def user_check_POST(self, authUser, user, request):
        return defer.succeed(authUser.login != "root" and authUser.login != "guest" and authUser.id != user.id)
    
    def user_auth_POST(self, authUser, user, request):
        
        def add_invitation(_):
            return self.invitationService.add_invitation(authUser, user, data)
        
        def complete(result):
            return defer.succeed({
                                  "id" : result.id,
                                  "owner" : result.owner.id,
                                  "creator" : result.creator.id,
                                  "text" : result.text,
                                  "type" : result.type,
                                  "status" : result.status
                                  })
        
        data = json.loads(request.content.read())
        
        d = defer.Deferred()
        
        d.addCallback(add_invitation)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d

class InvitationResource(UserResourceBase):
    
    implements(interface.IInvitationResource)
    
    def __init__(self, identity, invitationIdentity, service):
        UserResourceBase.__init__(self, identity, service)
        self.invitationService = IInvitationService(service)
        self.invitationIdentity = invitationIdentity
        self.putChild("accept", InvitationAcceptResource(self.identity, self.invitationIdentity, self.service))
        self.putChild("reject", InvitationRejectResource(self.identity, self.invitationIdentity, self.service))
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.login != "root" and authUser.login != "guest" and authUser.id == user.id)
    
    def user_auth_GET(self, authUser, user, request):
        
        def get_invitation(_):
            pass
        
        def complete(result):
            pass
        
        d = defer.Deferred()
        
        d.addCallback(get_invitation)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def user_check_DELETE(self, authUser, user, request):
        pass
    
    def user_auth_DELETE(self, authUser, user, request):
        
        def delete_invitation(_):
            pass
        
        def complete(result):
            pass
        
        d = defer.Deferred()
        
        d.addCallback(delete_invitation)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
class InvitationAcceptResource(UserResourceBase):
    
    def __init__(self, identity, invitationIdentity, service):
        pass
    
    def user_check_GET(self, authUser, user, request):
        pass
    
    def user_auth_GET(self, authUser, user, request):
        
        def accept_invitation(_):
            pass
        
        def complete(result):
            pass
        
        d = defer.Deferred()
        
        d.addCallback(accept_invitation)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
class InviattionRejectResource(UserResourceBase):
    
    def __init__(self, identity, invitationIdentity, service):
        pass
    
    def user_check_GET(self, authUser, user, request):
        pass
    
    def user_auth_GET(self, authUser, user, request):
        
        def reject_invitation(_):
            pass
        
        def complete(result):
            pass
        
        d = defer.Deferred()
        
        d.addCallback(reject_invitation)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
        