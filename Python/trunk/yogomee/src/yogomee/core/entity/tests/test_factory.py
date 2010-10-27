from zope.interface import implements
from twisted.trial import unittest
from twisted.internet import defer

from yogomee.core.entity import factory
from yogomee.core.entity import entity
from yogomee.core.entity import interface

from common import *

class Factory_tests(unittest.TestCase):
    
    def test_implements_IFactory(self):
        self.assertTrue(interface.IFactory.implementedBy(factory.Factory))
        
    def test__init__raises_TyepeError_if_entity_is_not_Entity(self):
        self.assertRaises(TypeError, factory.Factory, "not an Entity")
        
class Factory__init__tests(unittest.TestCase):
    
    def setUp(self):
        self.entity = TestEntity
        self.factory = factory.Factory(self.entity)
        
    def test_has_actual_entity(self):
        self.assertTrue(interface.IEntity.providedBy(self.factory.entity))
        
    def test_create_fails_with_AttributeError_if_field_that_not_exist(self):
        return self.assertFailure(self.factory.create(not_exists = "not exists"), AttributeError)
    
    def test_create_fails_with_TypeError_if_field_has_bad_type(self):
        return self.assertFailure(self.factory.create(field1 = 1, field3 = True), TypeError)
        
    def test_create_fails_with_AttributeError_if_not_all_required_fields(self):
        return self.assertFailure(self.factory.create(), AttributeError)
        
class Factory_create_tests(unittest.TestCase):
    
    def setUp(self):
        
        def complete(instance):
            self.instance = instance
        
        self.entity = TestEntity
        self.factory = factory.Factory(self.entity)
        
        d = self.factory.create(field1 = "field", field2 = 1, field3 = True)
        d.addCallback(complete)
        return d
    
    def test_callbacks_with_Entity(self):
        self.assertTrue(self.entity.providedBy(self.instance))
        
    def test_set_fields_values(self):
        self.assertEqual("field", self.instance.field1)
        self.assertEqual(1, self.instance.field2)
        self.assertEqual(True, self.instance.field3)
        
    def test_set_other_fields_to_None(self):
        self.assertEqual(None, self.instance.field4)
        
    def test_set_identity_to_None(self):
        self.assertEqual(None, self.instance.id)