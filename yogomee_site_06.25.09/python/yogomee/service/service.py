from zope.interface import implements

import interface
from yogomee.core import storage

class Service(object):
    
    implements(interface.IService)
    
    def __init__(self, storageFactory = None):
        self.storageFactory = storageFactory