from zope.interface import implements
from twisted.internet import defer, reactor

import interface

class ValueValidator(object):
    
    implements(interface.IValueValidator)
    
    def __init__(self, value):
        self.value = interface.IValue(value)
        
    def validate_field(self, field):
        
        def validate(field):
            fields = map(lambda field: field.name, self.value.fields())
            if field in fields:
                return defer.succeed(field)
            else:
                return defer.fail(AttributeError("No such field %s", field))
        
        def complete(field):
            return defer.succeed(field)
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, field)
        return d
    
    def validate_field_value(self, field, value):
        
        def validate((field, value)):
            
            def validate_field((field, value)):
                
                def complete(field):
                    return defer.succeed((field, value))
                
                d = self.validate_field(field)
                d.addCallback(complete)
                return d
            
            def validate_value((field, value)):
                types = dict(map(lambda field: (field.name, field.type), self.value.fields()))
                
                if interface.IValue.providedBy(types[field]):
                    if value is None:
                        return defer.succeed((field, value))
                    if not types[field].providedBy(value):
                        return defer.fail(TypeError("%s must be %s" % (field, types[field])))
                    return defer.succeed((field, value))

                if not isinstance(value, types[field]):
                    return defer.fail(TypeError("%s must be %s" % (field, types[field])))
                
                return defer.succeed((field, value))
            
            d = defer.Deferred()
            
            d.addCallback(validate_field)
            d.addCallback(validate_value)
            
            reactor.callLater(0, d.callback, (field, value))
            return d
        
        def complete((field, value)):
            return defer.succeed((field, value))
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, (field, value))
        return d
    
    def validate(self, value):
        
        def validate(value):
            if self.value.providedBy(value):
                return defer.succeed(value)
            else:
                return defer.fail(TypeError("Value must provide %s" % self.value.__name__))
        
        def complete(value):
            return defer.succeed(value)
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, value)
        return d
    
class EntityValidator(ValueValidator):
     
     implements(interface.IEntityValidator)
     
     def __init__(self, entity):
         self.entity = interface.IEntity(entity)
         ValueValidator.__init__(self, entity)
     
     def validate(self, entity):
         
         def validate(entity):
             if self.entity.providedBy(entity):
                 return defer.succeed(entity)
             else:
                 return defer.fail(TypeError("Entity must provide %s" % self.entity.__name__))
             return
         
         def complete(entity):
             return defer.succeed(entity)
         
         d = defer.Deferred()
         
         d.addCallback(validate)
         d.addBoth(complete)
         
         reactor.callLater(0, d.callback, entity)
         return d