from zope.interface import implements
from twisted.trial import unittest
from twisted.internet import defer, reactor

from yogomee.core.entity import repository
from yogomee.core.entity import factory
from yogomee.core.entity import entity
from yogomee.core.entity import interface
from yogomee.core import storage

from common import *

class Repository_tests(unittest.TestCase):
    
    def test_implement_IRepository(self):
        self.assertTrue(interface.IRepository.implementedBy(repository.Repository))
        
class Repository__init__tests(unittest.TestCase):
    pass

class Repository_add_tests(unittest.TestCase):
    
    def setUp(self):
        
        def create_entity(_):
            return self.entityFactory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def add_entity(instance):
            return self.repository.add(instance)
        
        def complete(instance):
            self.added = instance
            return defer.succeed(self.added)
        
        self.entity = TestEntity
        self.entityFactory = factory.Factory(self.entity)
        self.storageFactory = storage.memory.MemoryStorageFactory()
        self.repository = repository.Repository(self.entity, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(create_entity)
        d.addCallback(add_entity)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, 1)
        return d
    
    def test_callbacks_with_Entity(self):
        self.assertTrue(self.entity.providedBy(self.added))
        
    def test_set_identity(self):
        self.assertNotEqual(None, self.added.id)
        
class Repository_get_tests(unittest.TestCase):
    
    def setUp(self):
        
        def create_entity(_):
            return self.entityFactory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def add_entity(instance):
            return self.repository.add(instance)
        
        def get_entity(instance):
            self.instance = instance
            return self.repository.get(self.instance.id)
        
        def complete(instance):
            self.fetched = instance
            return defer.succeed(self.fetched)
        
        self.entity  = TestEntity
        self.entityFactory = factory.Factory(self.entity)
        self.storageFactory = storage.memory.MemoryStorageFactory()
        self.repository = repository.Repository(self.entity, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(create_entity)
        d.addCallback(add_entity)
        d.addCallback(get_entity)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, 1)
        return d
    
    def test_callbacks_with_Entity(self):
        self.assertTrue(self.entity.providedBy(self.fetched))
        
class Repository_where_tests(unittest.TestCase):
    
    def setUp(self):
        
        def create_entity1(_):
            return self.entityFactory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def add_entity1(instance):
            self.instance1 = instance
            return self.repository.add(self.instance1)
        
        def create_entity2(_):
            return self.entityFactory.create(field1 = "field", field2 = 2, field3 = False, field4 = 2.2)
        
        def add_entity2(instance):
            self.instance2 = instance
            return self.repository.add(self.instance2)
        
        def get(_):
            return self.repository.where(field1 = "field")
        
        def complete(results):
            self.fetched = results
            return defer.succeed(self.fetched)
        
        d = defer.Deferred()
        
        d.addCallback(create_entity1)
        d.addCallback(add_entity1)
        d.addCallback(create_entity2)
        d.addCallback(add_entity2)
        d.addCallback(get)
        d.addCallback(complete)
        
        self.entity = TestEntity
        self.entityFactory = factory.Factory(self.entity)
        self.storageFactory = storage.memory.MemoryStorageFactory()
        self.repository = repository.Repository(self.entity, self.storageFactory)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    def test_has_actual_count(self):
        self.assertEqual(2, len(self.fetched))
        
    def test_contains_instance1(self):
        self.assertIn(self.instance1, self.fetched)
        
    def test_contains_instance2(self):
        self.assertIn(self.instance2, self.fetched)
        
class Repository_persist_add_get_tests(unittest.TestCase):
    
    def setUp(self):
        
        def create_entity(_):
            return self.entityFactory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def add_entity(instance):
            return self.repository1.add(instance)
        
        def persist(instance):
            self.instance = instance
            return self.repository1.persist()
        
        def get_entity(instance):
            return self.repository2.get(self.instance.id)
        
        def complete(instance):
            self.fetched = instance
            return defer.succeed(instance)
        
        self.entity = TestEntity
        self.entityFactory = factory.Factory(self.entity)
        self.storageFactory = storage.memory.MemoryStorageFactory()
        self.repository1 = repository.Repository(self.entity, self.storageFactory)
        self.repository2 = repository.Repository(self.entity, self.storageFactory)
        
        d = defer.Deferred()
        
        d.addCallback(create_entity)
        d.addCallback(add_entity)
        d.addCallback(persist)
        d.addCallback(get_entity)
        d.addCallback(complete)
        
        reactor.callLater(0, d.callback, 1)
        return d
    
    def test_callbacks_with_Entity(self):
        self.assertTrue(self.entity.providedBy(self.fetched))
        
class Repository_persist_where_tests(unittest.TestCase):
    
    def setUp(self):
        
        def create_entity1(_):
            return self.entityFactory.create(field1 = "field", field2 = 1, field3 = True, field4 = 1.1)
        
        def add_entity1(instance):
            self.instance1 = instance
            return self.repository1.add(self.instance1)
        
        def create_entity2(_):
            return self.entityFactory.create(field1 = "field", field2 = 2, field3 = False, field4 = 2.2)
        
        def add_entity2(instance):
            self.instance2 = instance
            return self.repository1.add(self.instance2)
        
        def persist(_):
            return self.repository1.persist()
        
        def get(_):
            return self.repository2.where(field1 = "field")
        
        def complete(results):
            self.fetched = map(lambda res: res.id, results)
            return defer.succeed(self.fetched)
        
        d = defer.Deferred()
        
        d.addCallback(create_entity1)
        d.addCallback(add_entity1)
        d.addCallback(create_entity2)
        d.addCallback(add_entity2)
        d.addCallback(persist)
        d.addCallback(get)
        d.addCallback(complete)
        
        self.entity = TestEntity
        self.entityFactory = factory.Factory(self.entity)
        self.storageFactory = storage.memory.MemoryStorageFactory()
        self.repository1 = repository.Repository(self.entity, self.storageFactory)
        self.repository2 = repository.Repository(self.entity, self.storageFactory)
        
        reactor.callLater(0, d.callback, None)
        return d
    
    
    def test_has_actual_count(self):
        self.assertEqual(2, len(self.fetched))
        
    def test_contains_instance1(self):
        self.assertIn(self.instance1.id, self.fetched)
        
    def test_contains_instance2(self):
        self.assertIn(self.instance2.id, self.fetched)