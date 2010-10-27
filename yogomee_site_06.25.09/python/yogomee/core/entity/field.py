from zope.interface import implements
from zope.interface import Attribute

import interface

import types

class FieldBase(Attribute):
    
    implements(interface.IFieldBase)
    
    def __init__(self, type):
        Attribute.__init__(self, None, " ")
        if not isinstance(type, types.TypeType) and not interface.IEntity.providedBy(type):
            raise TypeError("type must be a Type")
        self.type = type
        
    def __get_name(self):
        return self.__name__
    
    def __set_name(self, name):
        self.__name__ = name
        
    name = property( __get_name, __set_name)

class Field(FieldBase):
    
    implements(interface.IField)
    
    def __init__(self, type, required = True, indexed = True):
        FieldBase.__init__(self, type)
        self.required = required
        self.indexed = indexed
        
class Identity(FieldBase):
    
    implements(interface.IIdentity)
    
    def __init__(self, type):
        FieldBase.__init__(self, type)
