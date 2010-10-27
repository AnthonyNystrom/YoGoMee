/* ------------------------------------------------
 * When_serializing_default_state.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Linq;
using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Specs_for_BrokenRuleException
{
    [TestClass]
    public sealed class When_serializing_default_state
    {
        private BrokenRuleException<Object> _exception, _exceptionDeserialized;

        public When_serializing_default_state()
        {
            _exception = new BrokenRuleException<Object>();
            _exceptionDeserialized = _exception.SerializeDeserialize();
        }

        [TestMethod]
        public void Entity_stays_null()
        {
            Assert.IsNull(_exceptionDeserialized.Entity);
        }

        [TestMethod]
        public void BrokenRulesCount_stays_empty()
        {
            Assert.AreEqual(0, _exceptionDeserialized.BrokenRules.Count());
        }

        [TestMethod]
        public void InnerException_stays_null()
        {
            Assert.IsNull(_exceptionDeserialized.InnerException);
        }

        [TestMethod]
        public void Message_stays_empty()
        {
            Assert.AreEqual("", _exceptionDeserialized.Message);
        }
    }
}
