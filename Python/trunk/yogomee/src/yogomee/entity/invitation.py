from yogomee.core.entity.entity import Entity
from yogomee.core.entity.field import Identity, Field

from user import User

import types

class Invitation(Entity):
    
    id = Identity(types.StringType)
    
    owner = Field(User)
    creator = Field(User)
    text = Field(types.StringType)
    status = Field(types.IntType)
    type = Field(types.IntType)