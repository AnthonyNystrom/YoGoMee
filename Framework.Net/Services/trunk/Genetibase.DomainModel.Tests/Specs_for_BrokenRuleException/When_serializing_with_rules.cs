/* ------------------------------------------------
 * When_serializing_with_rules.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;

namespace Specs_for_BrokenRuleException
{
    [TestClass]
    public sealed class When_serializing_with_rules
    {
        private BrokenRuleException<Object> _exception, _exceptionDeserialized;

        public When_serializing_with_rules()
        {
            _exception = new BrokenRuleException<Object>(new[] { new Rule<Object>(o => o != null) }, new Object());
            _exceptionDeserialized = _exception.SerializeDeserialize();
        }

        [TestMethod]
        public void Entity_is_persisted()
        {
            Assert.IsNotNull(_exceptionDeserialized.Entity);
        }

        [TestMethod]
        public void BrokenRulesCount_is_filled()
        {
            Assert.AreEqual(1, _exceptionDeserialized.BrokenRules.Count());
        }

        [TestMethod]
        public void InnerException_stays_null()
        {
            Assert.IsNull(_exceptionDeserialized.InnerException);
        }

        [TestMethod]
        public void Message_is_persisted()
        {
            Assert.IsFalse(String.IsNullOrEmpty(_exceptionDeserialized.Message));
        }
    }
}
