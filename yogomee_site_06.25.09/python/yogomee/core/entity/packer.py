from twisted.internet import defer
from interface import IEntity

class Packer(object):
    
    def __init__(self, entityClass):
        self.entityClass = IEntity(entityClass)
        
    def unpack_field(self, entity, field):
        
        def check((entity, field)):
            return self.check_field(entity, field)
        
        def unpack((entity, field)):
            return defer.succeed((entity, field, gettattr(entity, field)))
        
        def complete((entity, field, value)):
            return defer.succeed(value)
        
        d = defer.Deferred()
        
        d.addCallback(check)
        d.addCallback(unpack)
        d.addCallback(complete)
        
        d.callback((entity, field))
        return d
    
    def unpack_identity(self, entity):
        
        def check(entity):
            return self.check(entity)
        
        def unpack(entity):
            
            def get_identity(entity):
                return defer.succeed((entity, self.entityClass.identity()))
            
            def get_names((entity, identity)):
                return defer.succeed((entity, map(lambda f: f.name, identity)))
            
            def get_fields((entity, names)):
                
                def unpack((entity, names)):
                    list = map(lambda name: self.unpack_field(entity, name), names)
                    d = defer.DeferredList(list, fireOnOneErrback=True)
                    d.addCallback(lambda results: (entity, results))
                    return d
                
                def complete((entity, results)):
                    identity = ()
                    for (sucess, value) in results:
                        identity += (value,)
                    return defer.succeed((entity, identity))
                
                d = defer.Deferred()
                
                d.addCallback(unpack)
                d.addCallback(complete)
                
                d.callback((entity, names))
                return d
            
            def complete((entity, identity)):
                return defer.succeed((entity, identity))
            
            d = defer.Deferred()
            
            d.addCallback(get_identity)
            d.addCallback(get_fields)
            d.addCallback(complete)
            
            d.callback(entity)
            return d
        
        def complete(entity, identity):
            return defer.succeed(identity)
        
        d = defer.Deferred()
        
        d.addCallback(check)
        d.addCallback(unpack)
        d.addCallback(complete)
        
        d.callback(entity)
        return d
    
    def unpack_indexes(self, entity):
        
        def check(entity):
            return self.check(entity)
        
        def unpack(entity):
            
            def get_indexes(entity):
                identity = list(self.entityClass.identity())
                indexes = list(self.entityClass.indexed_fields())
                return defer.succeed((entity, filter(lambda f: f not in indentity, indexes)))
            
            def get_names((entity, indexes)):
                return defer.succeed((entity, map(lambda f: f.name, indexes)))
            
            def get_fields((entity, names)):
                
                def unpack((entity, names)):
                    list = map(lambda name: self.unpack_field(entity, name), names)
                    d = defer.DeferredList(list, fireOnOneErrback=True)
                    d.addCallback(lambda results: (entity, results))
                    return d
                
                def complete((entity, results)):
                    indexes = {}
                    for (name, (sucess, value)) in map(lambda name, result: (name, result), names, results):
                        indexes[name] = value
                    return defer.succeed((entity, indexes))
                
                d = defer.Deferred()
                
                d.addCallback(unpack)
                d.addCallback(complete)
                
                d.callback((entity, names))
                return d
            
            def complete((entity, indexes)):
                return defer.succeed((entity, indexes))
        
        def complete((entity, indexes)):
            return defer.succeed(indexes)
        
        d = defer.Deferred()
        
        d.addCallback(check)
        d.addCallback(unpack)
        d.addCallback(complete)
        
        d.callback(entity)
        return d
    
    def check(self, entity):
        
        def check(entity):
            if self.entityClass.providedBy(entity):
                return defer.succeed(entity)
            else:
                return defer.fail(TypeError("Entity must provide %s" % self.entityClass.__name__))
        
        d = defer.Deferred()
        d.addCallback(check)
        d.callback(entity)
        return d
    
    def check_field(self, entity, field):
        
        def check_entity(entity):
            return self.check(entity)
            
        def check_field(field):
            names = map(lambda field: field.name, self.entityClass.fields())
            if field in names:
                return defer.succeed((entity, field))
            else:
                return defer.fail(AttributeError("Field not exists."))
            
        def complete(((entity_success, entity), (field_sucess, field))):
            return defer.succeed((entity, field))
            
        d = defer.DeferredList([check_entity(entity), check_field(field)], fireOnOneErrback=True)
        d.addCallback(complete)
        return d