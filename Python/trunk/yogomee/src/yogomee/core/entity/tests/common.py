from zope.interface import implements

import yogomee.core.entity.entity as entity
import yogomee.core.entity.field as field

import types
            
class TestValue(entity.Value):
    
    field1 = field.Field(types.StringType)
    field2 = field.Field(types.IntType, required=False)
    field3 = field.Field(types.BooleanType, indexed=False)
    field4 = field.Field(types.FloatType, required=False, indexed=False)
    
class TestValueObject(object):
    
    implements(TestValue)
    
    def __init__(self):
        self.field1 = "field"
        self.field2 = 1
        self.field3 = True
        self.field4 = 1.1

class TestEntity(entity.Entity):
    
    id = field.Identity(types.StringType)
    
    field1 = field.Field(types.StringType)
    field2 = field.Field(types.IntType, required=False)
    field3 = field.Field(types.BooleanType, indexed=False)
    field4 = field.Field(types.FloatType, required=False, indexed=False)
    
class TestChildEntity(entity.Entity):
    
    id = field.Identity(types.StringType)
    
    parent = field.Field(TestEntity)
    field1 = field.Field(types.StringType)
    
class TestEntityObject(object):
    
    implements(TestEntity)
    
    def __init__(self):
        self.id = "id"
        
        self.field1 = "field"
        self.field2 = 1
        self.field3 = True
        self.field4 = 1.1