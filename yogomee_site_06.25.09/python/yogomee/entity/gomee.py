from yogomee.core.entity.entity import Entity
from yogomee.core.entity.field import Identity, Field

from user import User

import types

class Gomee(Entity):
    
    id = Identity(types.StringType)
    
    owner = Field(User)
    lat = Field(types.FloatType)
    lng = Field(types.FloatType)
    caption = Field(types.StringType)
    address = Field(types.StringType)
    description = Field(types.StringType)
    type = Field(types.IntType)