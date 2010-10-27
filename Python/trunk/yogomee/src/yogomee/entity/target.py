from yogomee.core.entity.entity import Entity
from yogomee.core.entity.field import Identity, Field

from user import User
from gomee import Gomee

import types

class Target(Entity):
    
    id = Identity(types.StringType)
    
    owner = Field(User)
    creator = Field(User)
    gomee = Field(Gomee)
    
    type = Field(types.IntType)
    
    text = Field(types.StringType, required=False, indexed=False)
    date = Field(types.IntType, required=False)