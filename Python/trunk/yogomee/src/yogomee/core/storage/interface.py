from zope.interface import Interface

class IStorageFactory(Interface):
    
    def get(entity):
        """
        """

class IStorage(Interface):
    
    def put(entity):
        """
        """
        
    def get(id):
        """
        """
        
    def where(**kwargs):
        """
        """
        
    def remove(entity):
        """
        """
    
    def count():
        """
        """