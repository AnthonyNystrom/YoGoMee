from zope.interface import implements
from twisted.internet import defer, reactor

from validator import ValueValidator, EntityValidator

import interface

class ValueUnpacker(object):
    
    implements(interface.IValueUnpacker)
    
    def __init__(self, value):
        self.value = interface.IValue(value)
        self.validator = ValueValidator(self.value) 
        
    def unpack_field(self, instance, field):
        
        def validate((instance, field)):
            
            def validate_instance((instance, field)):
                d = self.validator.validate(instance)
                d.addCallback(lambda _: defer.succeed((instance, field)))
                return d
            
            def validate_field((instance, field)):
                d = self.validator.validate_field(field)
                d.addCallback(lambda _: defer.succeed((instance, field)))
                return d
            
            def complete((instance, field)):
                return defer.succeed((instance, field))
            
            d = defer.Deferred()
            
            d.addCallback(validate_instance)
            d.addCallback(validate_field)
            d.addCallback(complete)
            
            reactor.callLater(0, d.callback, (instance, field))
            return d
        
        def unpack((instance, field)):
            
            def unpack((instance, field)):
                return defer.succeed((instance, field, getattr(instance, field)))
            
            def complete((instance, field, value)):
                return defer.succeed((instance, field, value))
            
            d = defer.Deferred()
            
            d.addCallback(unpack)
            d.addCallback(complete)
            
            reactor.callLater(0, d.callback, (instance, field))
            return d
        
        def complete((instance, field, value)):
            return defer.succeed(value)
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        d.addCallback(unpack)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, (instance, field))
        return d
    
    def unpack_required(self, instance):
        
        def validate(instance):
            return self.validator.validate(instance)
        
        def unpack(instance):
            
            def complete(results):
                required = {}
                for (name, (success, value)) in map(lambda name, result: (name, result), fields, results):
                    required[name] = value
                return defer.succeed((instance, required))
                
            fields = map(lambda field: field.name, self.value.required_fields())
            list = map(lambda field: self.unpack_field(instance, field), fields)
            
            d = defer.DeferredList(list, fireOnOneErrback = True)
            d.addCallback(complete)
            return d
        
        def complete((instance, required)):
            return defer.succeed(required)
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        d.addCallback(unpack)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, instance)
        return d
    
    def unpack_optional(self, instance):
        
        def validate(instance):
            return self.validator.validate(instance)
        
        def unpack(instance):
            
            def complete(results):
                optional = {}
                for (name, (success, value)) in map(lambda name, result: (name, result), fields, results):
                    optional[name] = value
                return defer.succeed((instance, optional))
                
            fields = map(lambda field: field.name, self.value.optional_fields())
            list = map(lambda field: self.unpack_field(instance, field), fields)
            
            d = defer.DeferredList(list, fireOnOneErrback = True)
            d.addCallback(complete)
            return d
        
        def complete((instance, optional)):
            return defer.succeed(optional)
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        d.addCallback(unpack)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, instance)
        return d
    
    def unpack_indexed(self, instance):
        
        def validate(instance):
            return self.validator.validate(instance)
        
        def unpack(instance):
            
            def complete(results):
                indexed = {}
                for (name, (success, value)) in map(lambda name, result: (name, result), fields, results):
                    indexed[name] = value
                return defer.succeed((instance, indexed))
                
            fields = map(lambda field: field.name, self.value.indexed_fields())
            list = map(lambda field: self.unpack_field(instance, field), fields)
            
            d = defer.DeferredList(list, fireOnOneErrback = True)
            d.addCallback(complete)
            return d
        
        def complete((instance, indexed)):
            return defer.succeed(indexed)
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        d.addCallback(unpack)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, instance)
        return d
    
class EntityUnpacker(ValueUnpacker):
    
    implements(interface.IEntityUnpacker)
    
    def __init__(self, entity):
        ValueUnpacker.__init__(self, entity)
        self.entity = interface.IEntity(entity)
        self.validator = EntityValidator(self.entity)
        
    def unpack_identity(self, instance):
        
        def validate(instance):
            return self.validator.validate(instance)
        
        def unpack(instance):
            return defer.succeed((instance, getattr(instance, self.entity.identity().name)))
        
        def complete((instance, identity)):
            return defer.succeed(identity)
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        d.addCallback(unpack)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, instance)
        return d