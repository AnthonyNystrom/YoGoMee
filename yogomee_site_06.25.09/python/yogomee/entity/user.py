from yogomee.core.entity.entity import Entity
from yogomee.core.entity.field import Identity, Field

import types

class User(Entity):
    
    id = Identity(types.StringType)
    
    login = Field(types.StringType)
    secret = Field(types.StringType)
    
class UserProfile(Entity):
    
    id = Identity(types.StringType)
    
    user = Field(User)
    firstName = Field(types.StringType)
    lastName = Field(types.StringType)
    email = Field(types.StringType)