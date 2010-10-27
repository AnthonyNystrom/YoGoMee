from yogomee.core.entity.entity import Entity
from yogomee.core.entity.field import Identity, Field

from user import User

import types

class Message(Entity):
    
    id = Identity(types.StringType)
    
    fromUser = Field(User)
    toUser = Field(User)
    
    msg = Field(types.StringType, indexed = False)
    status = Field(types.StringType)