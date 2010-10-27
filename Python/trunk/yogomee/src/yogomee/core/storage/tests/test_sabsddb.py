from zope.interface import implements
from twisted.trial import unittest
from twisted.internet import defer, reactor

from yogomee.core.entity.factory import Factory
from yogomee.core.storage import interface
from yogomee.core.storage import sabsddb

from yogomee.core.entity.tests.common import *

import uuid

class AbsddbStorageFactory_tests(unittest.TestCase):
    
    def test_implement_IStorageFactory(self):
        self.assertTrue(interface.IStorageFactory.implementedBy(sabsddb.AbsddbStorageFactory))
 
class AbsddbStorageFactory_get_tests(unittest.TestCase):
    
    def setUp(self):
        
        def get_storage(_):
            return self.factory.get(self.entity)
        
        def complete(storage):
            self.storage = storage
        
        self.entity = TestEntity
        self.factory = sabsddb.AbsddbStorageFactory(".")
        
        d = defer.Deferred()
        
        d.addCallback(get_storage)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
        
    def test_return_really_storage(self):
        self.assertTrue(interface.IStorage.providedBy(self.storage))
        
    def test_return_same_on_second_call(self):
        
        def get_storage(_):
            return self.factory.get(self.entity)
        
        def complete(storage):
            self.assertEqual(self.storage, storage)
        
        d = defer.Deferred()
        
        d.addCallback(get_storage)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
class AbsddbStorage_tests(unittest.TestCase):
    
    def test_implement_IStorage(self):
        self.assertTrue(interface.IStorage.implementedBy(sabsddb.AbsddbStorage))
        
class AbsddbStorage_put_tests(unittest.TestCase):
    
    def setUp(self):
        
        def get_storage(_):
            
            def complete(storage):
                self.storage = storage
                return defer.succeed(True)
            
            d = self.storageFactory.get(self.entity)
            d.addCallback(complete)
            return d
        
        def create_instance(_):
            
            def complete(instance):
                self.instance = instance
                self.instance.id = str(uuid.uuid4())
                return defer.succeed(True)
            
            d = self.factory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
            d.addCallback(complete)
            return d
        
        def put_instance(_):
            
            def complete(instance):
                self.puted = instance
                return defer.succeed(True)
            
            d = self.storage.put(self.instance)
            d.addCallback(complete)
            return d
        
        self.entity = TestEntity
        self.factory = Factory(self.entity) 
        self.storageFactory = sabsddb.AbsddbStorageFactory(".")
        
        d = defer.Deferred()
        
        d.addCallback(get_storage)
        d.addCallback(create_instance)
        d.addCallback(put_instance)
        
        reactor.callLater(0, d.callback, None)
        return d
        
    def test_callbacks_with_Entity(self):
        self.assertEqual(self.instance, self.puted)
        
class AbsddbStorage_child_put_tests(unittest.TestCase):
    
    def setUp(self):
        
        def get_parent_storage(_):
            
            def complete(storage):
                self.parentStorage = storage
                return defer.succeed(True)
            
            d = self.storageFactory.get(self.parent)
            d.addCallback(complete)
            return d
        
        def get_child_storage(_):
            
            def complete(storage):
                self.childStorage = storage
                return defer.succeed(True)
            
            d = self.storageFactory.get(self.child)
            d.addCallback(complete)
            return d
        
        def create_parent(_):
            return self.parentFactory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def put_parent(instance):
            self.parentInstance = instance
            self.parentInstance.id = str(uuid.uuid4())
            return self.parentStorage.put(self.parentInstance) 
        
        def create_child(instance):
            return self.childFactory.create(parent = instance, field1 = "field")
        
        def put_child(instance):
            self.childInstance = instance
            self.childInstance.id = str(uuid.uuid4())
            return self.childStorage.put(self.childInstance)
        
        def complete(instance):
            return defer.succeed(instance)
        
        self.storageFactory = sabsddb.AbsddbStorageFactory(".")
        
        self.parent = TestEntity
        self.parentFactory = Factory(self.parent)
        
        self.child = TestChildEntity
        self.childFactory = Factory(self.child)
        
        d = defer.Deferred()
        
        d.addCallback(get_parent_storage)
        d.addCallback(get_child_storage)
        d.addCallback(create_parent)
        d.addCallback(put_parent)
        d.addCallback(create_child)
        d.addCallback(put_child)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def test_callbacks_with_Entity(self):
        self.assertTrue(TestChildEntity.providedBy(self.childInstance))
        
class AbsddbStorage_get_tests(unittest.TestCase):
    
    def setUp(self):
        
        def get_storage(_):
            
            def complete(storage):
                self.storage = storage
                return defer.succeed(True)
            
            d = self.storageFactory.get(self.entity)
            d.addCallback(complete)
            return d
        
        def create(_):
            return self.factory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def put(instance):
            self.instance = instance
            self.instance.id = str(uuid.uuid4())
            return self.storage.put(self.instance)
        
        def get(instance):
            return self.storage.get(self.instance.id)
        
        def complete(instance):
            self.fetched = instance
            return defer.succeed(instance)
        
        self.entity = TestEntity
        self.factory = Factory(self.entity)
        self.storageFactory = sabsddb.AbsddbStorageFactory(".")
        
        d = defer.Deferred()
        
        d.addCallback(get_storage)
        d.addCallback(create)
        d.addCallback(put)
        d.addCallback(get)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, 1)
        return d
    
    def test_fails_with_AttributeError_if_entity_not_exists(self):
        return self.assertFailure(self.storage.get("no such entity"), AttributeError)
    
    def test_has_actual_type(self):
        self.assertTrue(self.entity.providedBy(self.fetched))
        
class AbsddbStorage_get_child_tests(unittest.TestCase):
    
    def setUp(self):
        
        def get_parent_storage(_):
            
            def complete(storage):
                self.parentStorage = storage
                return defer.succeed(True)
            
            d = self.storageFactory.get(self.parent)
            d.addCallback(complete)
            return d
        
        def get_child_storage(_):
            
            def complete(storage):
                self.childStorage = storage
                return defer.succeed(True)
            
            d = self.storageFactory.get(self.child)
            d.addCallback(complete)
            return d
        
        def create_parent(_):
            return self.parentFactory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def put_parent(instance):
            self.parentInstance = instance
            self.parentInstance.id = str(uuid.uuid4())
            return self.parentStorage.put(self.parentInstance)
        
        def create_child(instance):
            return self.childFactory.create(parent = instance, field1 = "field")
        
        def put_child(instance):
            self.childInstance = instance
            self.childInstance.id = str(uuid.uuid4())
            return self.childStorage.put(self.childInstance)
        
        def get_child(instance):
            return self.childStorage.get(instance.id)
        
        def complete(instance):
            self.fetched = instance
            return defer.succeed(instance)
        
        self.storageFactory = sabsddb.AbsddbStorageFactory(".")
        
        self.parent = TestEntity
        self.parentFactory = Factory(self.parent)
        
        self.child = TestChildEntity
        self.childFactory = Factory(self.child)
        
        d = defer.Deferred()
        
        d.addCallback(get_parent_storage)
        d.addCallback(get_child_storage)
        d.addCallback(create_parent)
        d.addCallback(put_parent)
        d.addCallback(create_child)
        d.addCallback(put_child)
        d.addCallback(get_child)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, 1)
        return d
    
    def test_has_actual_type(self):
        self.assertTrue(self.child.providedBy(self.fetched))
        
    def test_has_actual_parent(self):
        self.assertTrue(self.parent.providedBy(self.fetched.parent))
        
class AbssddbStorage_where_tests(unittest.TestCase):
    
    def setUp(self):
        
        def get_storage(_):
            
            def complete(storage):
                self.storage = storage
                return defer.succeed(True)
            
            d = self.storageFactory.get(self.entity)
            d.addCallback(complete)
            return d
        
        def get_before(_):
            
            def complete(result):
                self.before = result
                return defer.succeed(True)
                
            d = self.storage.where(field1 = "field")
            d.addCallback(complete)
            return d
        
        def create_entity1(_):
            return self.entityFactory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def put_entity1(instance):
            self.instance1 = instance
            self.instance1.id = str(uuid.uuid4())
            return self.storage.put(self.instance1)
        
        def create_entity2(_):
            return self.entityFactory.create(field1 = "field", field2 = 2, field3 = False, field4 = 2.2)
        
        def put_entity2(instance):
            self.instance2 = instance
            self.instance2.id = str(uuid.uuid4())
            return self.storage.put(self.instance2)
        
        def get(_):
            return self.storage.where(field1 = "field")
        
        def complete(result):
            self.fetched = result
            return defer.succeed(result)
        
        self.storageFactory = sabsddb.AbsddbStorageFactory(".")
        
        self.entity = TestEntity
        self.entityFactory = Factory(self.entity)
        
        d = defer.Deferred()
        
        d.addCallback(get_storage)
        d.addCallback(get_before)
        d.addCallback(create_entity1)
        d.addCallback(put_entity1)
        d.addCallback(create_entity2)
        d.addCallback(put_entity2)
        d.addCallback(get)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, 1)
        return d
    
    def test_has_actual_len(self):
        self.assertEqual(2, len(self.fetched) - len(self.before))
        
    def test_conatins_instance1(self):
        self.assertIn(self.instance1.id, self.fetched)
        
    def test_conatins_instance2(self):
        self.assertIn(self.instance2.id, self.fetched)