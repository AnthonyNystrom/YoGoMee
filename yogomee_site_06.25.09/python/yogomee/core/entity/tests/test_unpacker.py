from zope.interface import implements
from twisted.trial import unittest
from twisted.internet import defer

from yogomee.core.entity import entity
from yogomee.core.entity import field
from yogomee.core.entity import interface
from yogomee.core.entity import unpacker

from common import *

class ValueUnpacker_tests(unittest.TestCase):
    
    def test_implements_IValueUnpacker(self):
        self.assertTrue(interface.IValueUnpacker.implementedBy(unpacker.ValueUnpacker))
        
    def test__init__raises_TypeError_if_value_is_not_Value(self):
        self.assertRaises(TypeError, unpacker.ValueUnpacker, "not a Value")

class EntityUnpacker_tests(unittest.TestCase):
    
    def test_implements_IEntityUnpacker(self):
        self.assertTrue(interface.IEntityUnpacker.implementedBy(unpacker.EntityUnpacker))
        
    def test__init_raises_TypeError_if_entity_is_not_Entity(self):
        self.assertRaises(TypeError, unpacker.EntityUnpacker, "not an Entity")
        
class ValueUnpacker__init__tests(unittest.TestCase):
    
    def setUp(self):
        self.value = TestValue
        self.object = TestValueObject()
        self.unpacker = unpacker.ValueUnpacker(self.value)
        
    def test_has_actual_value(self):
        self.assertTrue(interface.IValue.providedBy(self.unpacker.value))
    
    def test_unpack_field_fails_with_TypeError_if_instance_is_not_Value(self):
        return self.assertFailure(self.unpacker.unpack_field("not a Value", "field1"), TypeError)
        
    def test_unpack_field_fails_with_AttributeError_if_field_not_exist(self):
        return self.assertFailure(self.unpacker.unpack_field(self.object, "no such field"), AttributeError)
    
    def test_unpack_required_fails_with_TypeError_if_instance_is_not_Value(self):
        return self.assertFailure(self.unpacker.unpack_required("not a Value"), TypeError)
    
    def test_unpack_optional_fails_with_TypeError_if_instance_is_not_Value(self):
        return self.assertFailure(self.unpacker.unpack_optional("not a Value"), TypeError)
    
    def test_unpack_indexed_fails_with_TypeError_if_instance_is_not_Value(self):
        return self.assertFailure(self.unpacker.unpack_indexed("not a Value"), TypeError)
    
class EntityUnpacker__init_tests(ValueUnpacker__init__tests):
    
    def setUp(self):
        self.value = TestEntity
        self.object = TestEntityObject()
        self.unpacker = unpacker.EntityUnpacker(self.value)
        
    def test_has_actual_entity(self):
        self.assertTrue(interface.IEntity.providedBy(self.unpacker.entity))
        
    def test_unpack_identity_fails_with_TypeError_if_instance_is_not_Entity(self):
        return self.assertFailure(self.unpacker.unpack_identity("not an Entity"), TypeError)
        
class ValueUnpacker_unpack_field_tests(unittest.TestCase):
    
    def setUp(self):
        
        def complete(results):
            self.results = results
        
        self.value = TestValue
        self.object = TestValueObject()
        self.unpacker = unpacker.ValueUnpacker(self.value)
        
        self.fields = map(lambda field: field.name, self.value.fields())
        self.list = map(lambda field: self.unpacker.unpack_field(self.object, field), self.fields)
        
        d = defer.DeferredList(self.list, consumeErrors = True)
        d.addCallback(complete)
        return d
    
    def test_no_errors(self):
        self.assertFalse(len(filter(lambda (success, result): not success, self.results)))
        
    def test_callbacks_with_actual_values(self):
        for (name, (success, value)) in map(lambda name, result: (name, result), self.fields, self.results):
            self.assertEqual(getattr(self.object, name), value)
            
class EntityUnpacker_unpack_field_tests(ValueUnpacker_unpack_field_tests):
    
    def setUp(self):
        
        def complete(results):
            self.results = results
        
        self.value = TestEntity
        self.object = TestEntityObject()
        self.unpacker = unpacker.EntityUnpacker(self.value)
        
        self.fields = map(lambda field: field.name, self.value.fields())
        self.list = map(lambda field: self.unpacker.unpack_field(self.object, field), self.fields)
        
        d = defer.DeferredList(self.list, consumeErrors = True)
        d.addCallback(complete)
        return d

class ValueUnpacker_unpack_required_tests(unittest.TestCase):
    
    def setUp(self):
        
        def complete(results):
            self.results = results
        
        self.value = TestValue
        self.object = TestValueObject()
        self.unpacker = unpacker.ValueUnpacker(self.value)
        
        self.fields = map(lambda field: field.name, self.value.required_fields())
        
        d = self.unpacker.unpack_required(self.object)
        d.addCallback(complete)
        return d
    
    def test_callbacks_with_actual_results_count(self):
        self.assertEqual(len(self.fields), len(self.results))
        
    def test_callbacks_with_actual_results(self):
        for field in self.fields:
            self.assertEqual(getattr(self.object, field), self.results[field])
            
class EntityUnpacker_unpack_required_tests(ValueUnpacker_unpack_required_tests):
    
    def setUp(self):
        
        def complete(results):
            self.results = results
        
        self.value = TestEntity
        self.object = TestEntityObject()
        self.unpacker = unpacker.EntityUnpacker(self.value)
        
        self.fields = map(lambda field: field.name, self.value.required_fields())
        
        d = self.unpacker.unpack_required(self.object)
        d.addCallback(complete)
        return d
            
class ValueUnpacker_unpack_optional_tests(unittest.TestCase):
    
    def setUp(self):
        
        def complete(results):
            self.results = results
        
        self.value = TestValue
        self.object = TestValueObject()
        self.unpacker = unpacker.ValueUnpacker(self.value)
        
        self.fields = map(lambda field: field.name, self.value.optional_fields())
        
        d = self.unpacker.unpack_optional(self.object)
        d.addCallback(complete)
        return d
    
    def test_callbacks_with_actual_results_count(self):
        self.assertEqual(len(self.fields), len(self.results))
        
    def test_callbacks_with_actual_results(self):
        for field in self.fields:
            self.assertEqual(getattr(self.object, field), self.results[field])
            
class EntityUnpacker_unpack_optional_tests(ValueUnpacker_unpack_optional_tests):
    
    def setUp(self):
        
        def complete(results):
            self.results = results
        
        self.value = TestEntity
        self.object = TestEntityObject()
        self.unpacker = unpacker.EntityUnpacker(self.value)
        
        self.fields = map(lambda field: field.name, self.value.optional_fields())
        
        d = self.unpacker.unpack_optional(self.object)
        d.addCallback(complete)
        return d
            
class ValueUnpacker_unpack_indexed_tests(unittest.TestCase):
    
    def setUp(self):
        
        def complete(results):
            self.results = results
        
        self.value = TestValue
        self.object = TestValueObject()
        self.unpacker = unpacker.ValueUnpacker(self.value)
        
        self.fields = map(lambda field: field.name, self.value.indexed_fields())
        
        d = self.unpacker.unpack_indexed(self.object)
        d.addCallback(complete)
        return d
    
    def test_callbacks_with_actual_results_count(self):
        self.assertEqual(len(self.fields), len(self.results))
        
    def test_callbacks_with_actual_results(self):
        for field in self.fields:
            self.assertEqual(getattr(self.object, field), self.results[field])
            
class EntityUnpacker_unpack_indexed_tests(ValueUnpacker_unpack_indexed_tests):
    
    def setUp(self):
        
        def complete(results):
            self.results = results
        
        self.value = TestEntity
        self.object = TestEntityObject()
        self.unpacker = unpacker.EntityUnpacker(self.value)
        
        self.fields = map(lambda field: field.name, self.value.indexed_fields())
        
        d = self.unpacker.unpack_indexed(self.object)
        d.addCallback(complete)
        return d        
    
class EntityUnpacker_unpack_identity_tests(unittest.TestCase):
    
    def setUp(self):
        
        def complete(result):
            self.result = result
        
        self.value = TestEntity
        self.object = TestEntityObject()
        self.unpacker = unpacker.EntityUnpacker(self.value)
        
        self.identity = self.value.identity().name
        
        d = self.unpacker.unpack_identity(self.object)
        d.addCallback(complete)
        return d
    
    def test_callbacks_with_actual_result(self):
        self.assertEqual(getattr(self.object, self.identity), self.result)