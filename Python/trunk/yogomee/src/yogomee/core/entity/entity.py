from zope.interface import Interface, Attribute, implements, providedBy
from zope.interface.interface import InterfaceClass
from zope.interface.declarations import classImplements

import interface
        
class ValueClass(InterfaceClass):
    
    def __init__(self, name, bases=(), attrs=None, __doc__=None, __module__=None):
        InterfaceClass.__init__(self, name, bases, attrs, __doc__, __module__)
    
    def fields(self):
        for attr in self._InterfaceClass__attrs.values():
            if interface.IField.providedBy(attr):
                yield interface.IField(attr)
                
    def required_fields(self):
        for field in self.fields():
            if field.required:
                yield field
                
    def indexed_fields(self):
        for field in self.fields():
            if field.indexed:
                yield field
                
    def optional_fields(self):
        for field in self.fields():
            if not field.required:
                yield field 

Value = ValueClass("Value", __module__ = "yogomee.entity")
classImplements(ValueClass, interface.IValue)

class EntityClass(ValueClass):
    
    def __init__(self, name, bases=(), attrs=None, __doc__=None, __module__=None):
        ValueClass.__init__(self, name, bases, attrs, __doc__, __module__)
        identity = filter(lambda attr: interface.IIdentity.providedBy(attr), self._InterfaceClass__attrs.values())
        if __module__ != "yogomee.entity":
            if not len(identity):
                raise TypeError("No identity")
            if len(identity) > 1:
                raise TypeError("Entity must have only one Identity")
            self.__identity = identity[0]
    
    def identity(self):
        return self.__identity
                
Entity = EntityClass("Entity", __module__ = "yogomee.entity")
classImplements(EntityClass, interface.IEntity)