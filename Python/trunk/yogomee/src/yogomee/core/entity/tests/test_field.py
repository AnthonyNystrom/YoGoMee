from zope.interface import implements
from twisted.trial import unittest

import yogomee.core.entity.interface as interface
import yogomee.core.entity.field as field

import types

class FieldBase_tests(unittest.TestCase):
    
    def test_implemets_IFieldBase(self):
        self.assertTrue(interface.IFieldBase.implementedBy(field.FieldBase))
        
    def test___init__raises_TypeError_if_type_is_not_Type(self):
        self.assertRaises(TypeError, field.FieldBase, "non Type")

class FieldBase__init__tests(unittest.TestCase):
    
    def setUp(self):
        self.field = field.FieldBase(types.StringType)
    
    def test_provide_IField(self):
        self.assertTrue(interface.IFieldBase.providedBy(self.field))
    
    def test_has_actual_type(self):
        self.assertEqual(types.StringType, self.field.type)
        
    def test_has_actual_name(self):
        self.assertEqual(None, self.field.name)

class Field_tests(FieldBase_tests):
    
    def test_implements_IField(self):
        self.assertTrue(interface.IField.implementedBy(field.Field))
        
    def test__init__raises_TypeError_if_required_is_not_Boolean(self):
        self.assertRaises(TypeError, field.Field, required = "not Boolean", indexed = True)
        
    def test__init__raises_TypeError_if_indexed_is_not_Boolean(self):
        self.assertRaises(TypeError, field.Field, indexed = "not Boolean", required = True)

class Field__init__tests(FieldBase__init__tests):
    
    def setUp(self):
        self.field = field.Field(types.StringType, False, False)
        
    def test_provide_IField(self):
        self.assertTrue(interface.IField.providedBy(self.field))
        
    def test_has_actual_required(self):
        self.assertEqual(False, self.field.required)
        
    def test_has_actual_indexed(self):
        self.assertEqual(False, self.field.indexed)

class Identity_tests(FieldBase_tests):
    
    def test_implements_IIdentity(self):
        self.assertTrue(interface.IIdentity.implementedBy(field.Identity))

class Identity__init__tests(FieldBase__init__tests):
    
    def setUp(self):
        self.field = field.Identity(types.StringType)
        
    def test_provide_IIdentity(self):
        self.assertTrue(interface.IIdentity.providedBy(self.field))