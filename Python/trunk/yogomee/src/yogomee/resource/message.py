from zope.interface import implements
from twisted.internet import defer, reactor

from yogomee.service.interface import IMessageService
from yogomee.service.message import MessageService
from resource import UserResourceBase

import interface

class MessagesResource(UserResourceBase):
    
    implements(interface.IMessagesResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.messageService = IMessageService(service)
        self.putChild("sent", MessagesSentResource(identity, service))
        self.putChild("received", MessagesReceivedResource(identity, service))
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.id == user.id)
    
    def user_auth_GET(self, authUser, user, request):
        
        def complete(messages):
            msgs = map(lambda msg: {
                                    "id" : msg.id,
                                    "from" : msg.fromUser.id,
                                    "to" : msg.toUser.id,
                                    "msg" : msg.msg,
                                    "status" : msg.status
                                    }, messages)
            return defer.succeed(msgs)
        
        d = self.messageService.get_messages(user)
        d.addCallback(complete)
        return d
    
    def user_check_POST(self, authUser, user, request):
        return defer.succeed(authUser.id != user.id)
    
    def user_auth_POST(self, authUser, user, request):
        
        def add_msg(_):
            msg = json.loads(base64.urlsafe_b64decode(request.args["msg"][0]))
            msg = str(msg["msg"])
            return self.messageService.add_message(authUser, user, msg)
            
        def complete(msg):
            return defer.succeed({
                                  "id" : msg.id,
                                  "from" : msg.fromUser.id,
                                  "to" : msg.toUser.id,
                                  "msg" : msg.msg,
                                  "status" : msg.status
                                  })
        
        d = defer.Deferred()
        
        d.addCallback(add_msg)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def getChild(self, path, request):
        return MessageResource(self.identity, path, self.service)

class MessageResource(UserResourceBase):
    
    implements(interface.IMessageResource)
    
    def __init__(self, identity, msgIdentity, service):
        UserResourceBase.__init__(self, identity, service)
        self.messageService = IMessageService(service)
        self.msgIdentity = msgIdentity
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.id == user.id)
    
    def user_auth_GET(self, authUser, user, request):
        
        def complete(msg):
            return defer.succeed({
                                  "id" : msg.id,
                                  "from" : msg.fromUser.id,
                                  "to" : msg.toUser.id,
                                  "msg" : msg.msg,
                                  "status" : msg.status
                                  })
        
        d = self.messageService.get_message(self.msgIdentity)
        d.addCallback(complete)
        return d

    
class MessagesSentResource(UserResourceBase):
    
    implements(interface.IMessagesSentResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.messageService = IMessageService(service)
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.id == user.id)
    
    def user_auth_GET(self, authUser, user, request):
        
        def complete(messages):
            msgs = map(lambda msg: {
                                    "id" : msg.id,
                                    "from" : msg.fromUser.id,
                                    "to" : msg.toUser.id,
                                    "msg" : msg.msg,
                                    "status" : msg.status
                                    }, messages)
            return defer.succeed(msgs)
        
        d = self.messageService.get_sent_messages(user)
        d.addCallback(complete)
        return d
    
class MessagesReceivedResource(UserResourceBase):
    
    implements(interface.IMessagesReceivedResource)
    
    def __init__(self, identity, service):
        UserResourceBase.__init__(self, identity, service)
        self.messageService = IMessageService(service)
        
    def user_check_GET(self, authUser, user, request):
        return defer.succeed(authUser.id == user.id)
    
    def user_auth_GET(self, authUser, user, request):
        
        def complete(messages):
            msgs = map(lambda msg: {
                                    "id" : msg.id,
                                    "from" : msg.fromUser.id,
                                    "to" : msg.toUser.id,
                                    "msg" : msg.msg,
                                    "status" : msg.status
                                    }, messages)
            return defer.succeed(msgs)
        
        d = self.messageService.get_received_messages(user)
        d.addCallback(complete)
        return d