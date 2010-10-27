from zope.interface import implements

import interface

class PickleEncoder(object):
    
    implements(interface.IEncoder)
    
    def __init__(self, entityClass):
        self.entityClass = interface.IEntity(entityClass)
        
    def encode(self, entity):
        pass
    
    def decode(self, data):
        pass