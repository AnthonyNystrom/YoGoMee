from zope.interface import implements, classImplements
from twisted.internet import defer, reactor

from validator import EntityValidator

import interface

class Factory(object):
    
    implements(interface.IFactory)
    
    def __init__(self, entity):
        self.entity = interface.IEntity(entity)
        self.validator = EntityValidator(self.entity)
        self.cls = type("%sClass" % self.entity.__name__, (object,), {})
        classImplements(self.cls, self.entity)
    
    def create(self, **kwargs):
        
        def validate(kwargs):
             
             def validate_fields(kwargs):
                 
                 def complete(results):
                     if len(filter(lambda (success, result): not success, results)):
                         return defer.fail(AttributeError("Field not exist."))
                     return defer.succeed(kwargs)
                 
                 list = map(lambda field: self.validator.validate_field(field), kwargs.keys())
                 d = defer.DeferredList(list, consumeErrors = True)
                 d.addCallback(complete)
                 return d
             
             def validate_values(kwargs):
                 
                 def complete(results):
                     for (success, value) in results:
                         if not success:
                             return defer.fail(value)
                     return defer.succeed(kwargs)
                 
                 list = map(lambda field: self.validator.validate_field_value(field, kwargs[field]), kwargs.keys())
                 d = defer.DeferredList(list, consumeErrors = True)
                 d.addCallback(complete)
                 return d
             
             def validate_required(kwargs):
                 fields = map(lambda field: field.name, self.entity.required_fields())
                 for field in fields:
                     if field not in kwargs.keys():
                         return defer.fail(AttributeError("Not all required fields."))
                 return defer.succeed(kwargs)
             
             def create_instance(kwargs):
                 return defer.succeed((self.cls(), kwargs))
             
             def set_fields((instance, kwargs)):
                 
                 def set_kwargs((instance, fields, kwargs)):
                     for field in filter(lambda field: field in kwargs.keys(), fields):
                         setattr(instance, field, kwargs[field])
                     return defer.succeed((instance, fields, kwargs))
                 
                 def set_none((instance, fields, kwargs)):
                     for field in filter(lambda field: field not in kwargs.keys(), fields):
                         setattr(instance, field, None)
                     return defer.succeed(instance)
                 
                 def complete(instance):
                     return defer.succeed(instance)
                 
                 d = defer.Deferred()
                 
                 d.addCallback(set_kwargs)
                 d.addCallback(set_none)
                 d.addCallback(complete)
                 
                 reactor.callLater(0, d.callback, (instance, map(lambda field: field.name, self.entity.fields()), kwargs))
                 return d
             
             def set_identity(instance):
                 setattr(instance, self.entity.identity().name, None)
                 return defer.succeed(instance)
             
             def complete(instance):
                 return defer.succeed(instance)
             
             d = defer.Deferred()
             
             d.addCallback(validate_fields)
             d.addCallback(validate_values)
             d.addCallback(validate_required)
             d.addCallback(create_instance)
             d.addCallback(set_fields)
             d.addCallback(set_identity)
             d.addCallback(complete)
             
             reactor.callLater(0, d.callback, kwargs)
             return d
        
        d = defer.Deferred()
        
        d.addCallback(validate)
        
        reactor.callLater(0, d.callback, kwargs)
        return d
        