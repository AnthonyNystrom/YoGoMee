from yogomee.core.entity.entity import Entity
from yogomee.core.entity.field import Identity, Field

import types

class Tag(Entity):
    
    id = Identity(types.StringType)
    name = Field(types.StringType)