from zope.interface import implements
from twisted.trial import unittest
from twisted.internet import defer

from yogomee.core.entity import entity
from yogomee.core.entity import field
from yogomee.core.entity import interface

from common import *

class Value_tests(unittest.TestCase):
    
    def test_implements_IValue(self):
        self.assertTrue(interface.IValue.providedBy(entity.Value))
        
class Entity_tests(Value_tests):
    
    def test_implements_IEntity(self):
        self.assertTrue(interface.IEntity.providedBy(entity.Entity))

class Value_fields_tests(unittest.TestCase):
    
    def setUp(self):
        self.value = TestValue
        self.fields = list(self.value.fields())
        
    def test_has_actual_fields_count(self):
        self.assertEqual(4, len(self.fields))
        
    def test_has_actual_fields_names(self):
        fields = map(lambda f: f.name, self.fields)
        self.assertIn("field1", fields)
        self.assertIn("field2", fields)
        self.assertIn("field3", fields)
        self.assertIn("field4", fields)
        
    def test_has_actual_fields_types(self):
        for field in self.fields:
            self.assertTrue(interface.IField.providedBy(field))
        
class Entity_fields_tests(Value_fields_tests):
    
    def setUp(self):
        self.value = TestEntity
        self.fields = list(self.value.fields())
        
class Value_required_fields_tests(unittest.TestCase):
    
    def setUp(self):
        self.value = TestValue
        self.fields = list(self.value.required_fields())
        
    def test_has_actual_fields_count(self):
        self.assertEqual(2, len(self.fields))
        
    def test_has_actual_fields_names(self):
        fields = map(lambda f: f.name, self.fields)
        self.assertIn("field1", fields)
        self.assertIn("field3", fields)
        
    def test_has_actual_required(self):
        self.assertEqual(2, len(filter(lambda f: f.required, self.fields)))
        
class Entity_required_fields_tests(Value_required_fields_tests):
    
    def setUp(self):
        self.value = TestEntity
        self.fields = list(self.value.required_fields())
        
class Value_optional_fields_tests(unittest.TestCase):
    
    def setUp(self):
        self.value = TestValue
        self.fields = list(self.value.optional_fields())
        
    def test_has_actual_fields_count(self):
        self.assertEqual(2, len(self.fields))
        
    def test_has_actual_fields_names(self):
        fields = map(lambda f: f.name, self.fields)
        self.assertIn("field2", fields)
        self.assertIn("field4", fields)
        
    def test_has_actual_required(self):
        self.assertEqual(2, len(filter(lambda f: not f.required, self.fields)))
        
class Entity_optional_fields_tests(Value_optional_fields_tests):
    
    def setUp(self):
        self.value = TestEntity
        self.fields = list(self.value.optional_fields())
        
class Value_indexed_fields_tests(unittest.TestCase):
    
    def setUp(self):
        self.value = TestValue
        self.fields = list(self.value.indexed_fields())
        
    def test_has_actual_fields_count(self):
        self.assertEqual(2, len(self.fields))
        
    def test_has_actual_fields(self):
        fields = map(lambda f: f.name, self.fields)
        self.assertIn("field1", fields)
        self.assertIn("field2", fields)
        
    def test_has_actual_indexed(self):
        self.assertEqual(2, len(filter(lambda f: f.indexed, self.fields)))
        
class Entity_indexed_fields_tests(Value_indexed_fields_tests):
    
    def setUp(self):
        self.value = TestEntity
        self.fields = list(self.value.indexed_fields())
        
class Entity_identity_tests(unittest.TestCase):
    
    def setUp(self):
        self.value = TestEntity
        self.identity = self.value.identity()
    
    def test_has_actual_identity(self):
        self.assertTrue(interface.IIdentity.providedBy(self.identity))
        
    def test_has_actual_identity_name(self):
        self.assertEqual("id", self.identity.name)
        
    def test_has_actual_identity_type(self):
        self.assertEqual(types.StringType, self.identity.type)