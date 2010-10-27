from zope.interface import implements
from twisted.trial import unittest
from twisted.internet import defer

import yogomee.core.entity.validator as validator
import yogomee.core.entity.entity as entity
import yogomee.core.entity.interface as interface

from common import *

class ValueValidator_tests(unittest.TestCase):
    
    def test_implements_IValueValidator(self):
        self.assertTrue(interface.IValueValidator.implementedBy(validator.ValueValidator))
        
    def test__init__raises_TypeError_if_value_is_not_Value(self):
        self.assertRaises(TypeError, validator.ValueValidator, value="not Value")

class EntityValidator_tests(unittest.TestCase):
    
    def test_implements_IEntityValidator(self):
        self.assertTrue(interface.IEntityValidator.implementedBy(validator.EntityValidator))
        
    def test__init_raises_TypeError_if_entity_is_not_Entity(self):
        self.assertRaises(TypeError, validator.EntityValidator, entity="not Entity")
        
class ValueValidator__init__tests(unittest.TestCase):
    
    def setUp(self):
        self.value = TestValue 
        self.validator = validator.ValueValidator(self.value)
        
    def test_has_actual_value(self):
        self.assertTrue(interface.IValue.providedBy(self.validator.value))
        
    def test_validate_field_fails_with_field_that_does_not_exists(self):
        return self.assertFailure(self.validator.validate_field("no such field"), AttributeError)
    
    def test_validate_field_value_fails_with_value_of_bat_type(self):
        return self.assertFailure(self.validator.validate_field_value("field1", 1), TypeError)
    
    def test_validate_fails_if_value_is_not_Value(self):
        return self.assertFailure(self.validator.validate("no Value"), TypeError)
        
class EntityValidator__init__tests(ValueValidator__init__tests):
    
    def setUp(self):
        self.value = TestEntity
        self.validator = validator.EntityValidator(self.value)
        
    def test_has_actual_entity(self):
        self.assertTrue(interface.IEntity.providedBy(self.value))
        
    def test_balidate_fails_if_entity_is_not_Entity(self):
        return self.assertFailure(self.validator.validate("no Entity"), TypeError)
        
class ValueValidator_validate_field_tests(unittest.TestCase):
    
    def setUp(self):
        
        def complete(result):
            self.result = result
            
        self.value = TestValue
        self.validator = validator.ValueValidator(self.value)
        self.fields = map(lambda field: field.name, self.value.fields())
        list = map(lambda field: self.validator.validate_field(field), self.fields)
        d = defer.DeferredList(list, consumeErrors = True)
        d.addCallback(complete)
        return d
    
    def test_no_errors(self):
        self.assertFalse(len(filter(lambda (success, result): not success, self.result)))
        
    def test_callbacks_with_name(self):
        for (name, (succes, value)) in map(lambda name, result: (name, result), self.fields, self.result):
            self.assertEqual(name, value)

class EntityValidator_validate_field_tests(ValueValidator_validate_field_tests):
    
    def setUp(self):
        
        def complete(result):
            self.result = result
            
        self.value = TestEntity
        self.validator = validator.EntityValidator(self.value)
        self.fields = map(lambda field: field.name, self.value.fields())
        list = map(lambda field: self.validator.validate_field(field), self.fields)
        d = defer.DeferredList(list, consumeErrors = True)
        d.addCallback(complete)
        return d        
    
class ValueValidator_validate_tests(unittest.TestCase):
    
    class Test(object):
        implements(TestValue)
    
    def setUp(self):
        
        def complete(value):
            self.returnedValue = value
            
        self.value = TestValue
        self.testValue = self.Test()
        self.validator = validator.ValueValidator(self.value)
        d = self.validator.validate(self.testValue)
        d.addCallback(complete)
        return d
    
    def test_callbacks_with_value(self):
        self.assertEqual(self.testValue, self.returnedValue)
        
class EntityValidator_validate_tests(unittest.TestCase):
    
    class Test(object):
        implements(TestEntity)
        
    def setUp(self):
        
        def complete(entity):
            self.returnedEntity = entity
            
        self.entity = TestEntity
        self.testEntity = self.Test()
        self.validator = validator.EntityValidator(self.entity)
        d = self.validator.validate(self.testEntity)
        d.addCallback(complete)
        return d
    
    def test_callbacks_with_value(self):
        self.assertEqual(self.testEntity, self.returnedEntity)
        