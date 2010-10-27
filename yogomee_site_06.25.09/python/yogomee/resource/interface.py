from twisted.web import resource

class IResource(resource.IResource):
    pass

class IAuthResource(IResource):
    pass

class IUsersResource(IAuthResource):
    pass

class IUserResourceBase(IAuthResource):
    pass

class IUserResource(IUserResourceBase):
    pass

class IUserProfileResource(IUserResourceBase):
    pass

class IMessagesResource(IUserResourceBase):
    pass

class IMessagesSentResource(IUserResourceBase):
    pass

class IMessagesReceivedResource(IUserResourceBase):
    pass

class IMessageResource(IUserResourceBase):
    pass

class IGomeesResource(IUserResourceBase):
    pass

class IGomeeResource(IUserResourceBase):
    pass

class IFriendsResource(IUserResourceBase):
    pass