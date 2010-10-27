from yogomee.core.entity.entity import Entity
from yogomee.core.entity.field import Identity, Field

from user import User

import types

class Friend(Entity):
    
    id = Identity(types.StringType)
    
    user1 = Field(User)
    user2 = Field(User)