from zope.interface import Interface, implements, Attribute

class IService(Interface):
    
    storageFactory = Attribute("storageFactory")

class IEncodeService(IService):
    
    def encode(entity):
        """
        """

class IAuthService(IService):
    
    def auth_user(request):
        """
        """

class IUserService(IService):
    
    def get_user(id):
        """
        """
        
    def add_user(login, secret):
        """
        """
        
    def del_user(user):
        """
        """
    
    def get_users(left, right, top, bottom):
        """
        """
        
class IUserProfileService(IService):
    
    def get_user_profile(user):
        """
        """
        
    def update_user_profile(profile):
        """
        """
        
class IMessageService(IService):
    
    def add_message(fromUser, toUser, msg):
        """
        """
    
    def get_message(id):
        """
        """
    
    def get_messages(user):
        """
        """
        
    def get_sent_messages(user):
        """
        """
        
    def get_received_messages(user):
        """
        """

class IGomeeService(IService):
    
    def add_gomee(owner, lat, lng, caption, address, description):
        """
        """
    
    def save_gomee(id, lat, lng, caption, address, description):
        """
        """
    
    def get_gomee(id):
        """
        """
    
    def del_gomee(id):
        """
        """
        
    def get_gomees(user):
        """
        """
        
    def get_profile_gomees(user):
        """
        """

class IFriendService(IService):
    
    def get_friends(user):
        """
        """

class IInvitationService(IService):
    
    def get_ivitation(id):
        """
        """
        
    def get_invitations(user):
        """
        """
        