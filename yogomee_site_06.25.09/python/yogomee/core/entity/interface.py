from zope.interface import Interface, Attribute
from zope.interface.interfaces import IInterface, IAttribute

class IFieldBase(IAttribute):
    """
    Field descriptor
    """
    name = Attribute("name")
    type = Attribute("type")

class IField(IFieldBase):
    
    required = Attribute("required")
    indexed = Attribute("indexed")

class IIdentity(IFieldBase):
    """
    Identity descriptor
    """

class IValue(IInterface):
    """
    Descriptor for Value metaclass.
    """
    def fields():
        """
        Retuens all fields.
        """
        
    def required_fields():
        """
        Returns required fields.
        """
    
    def optional_fields():
        """
        Returns optional fields.
        """
    
    def indexed_fields():
        """
        Returns indexed fileds.
        """

class IEntity(IValue):
    """
    Descriptor for Entity (Value that have identity) metaclass.
    """
    
    def identity():
        """
        Returns identity fields.
        """

class IFactory(Interface):
    """
    Factory creates new entities.
    """
    
    def create(**kwargs):
        """
        Create new entity with fields in **kwargs
        """

class IRepository(Interface):
    
    def add(entity):
        """
        """
        
    def get(id):
        """
        """
        
    def remove(entity):
        """
        """
        
    def count():
        """
        """
        
    def where(first, count, **kwargs):
        """
        """        

class IEncoder(Interface):
    
    def encode(entity):
        """
        """
        
    def decode(data):
        """
        """
        
class IValueUnpacker(Interface):
    
    def unpack_field(value, field):
        """
        """
    
    def unpack_required(value):
        """
        """
    
    def unpack_optional(value):
        """
        """
        
    def unpack_indexes(value):
        """
        """
        
    def unpack(value):
        """
        """

class IEntityUnpacker(IValueUnpacker):
    
    def unpack_identity(entity):
        """
        """        

class IValueValidator(Interface):
        
    def validate_field(field):
        """
        """
    
    def validate_field_value(field, value):
        """
        """
    
    def validate(value):
        """
        """
        
class IEntityValidator(IValueValidator):
    """
    """