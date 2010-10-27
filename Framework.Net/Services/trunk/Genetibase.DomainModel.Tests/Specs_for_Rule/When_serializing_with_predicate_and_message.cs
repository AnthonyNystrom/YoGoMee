/* ------------------------------------------------
 * When_serializing_with_predicate_and_message.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Specs_for_Rule
{
    [TestClass]
    public sealed class When_serializing_with_predicate_and_message
    {
        private Rule<Object> _rule;
        private Rule<Object> _ruleDeserialized;

        public When_serializing_with_predicate_and_message()
        {
            _rule = new Rule<Object>(o => o != null, "o != null");
            _ruleDeserialized = _rule.SerializeDeserialize();
        }

        [TestMethod]
        public void Message_is_persisted()
        {
            Assert.AreEqual("o != null", _ruleDeserialized.Message);
        }

        [TestMethod]
        public void Predicate_is_persisted()
        {
            Assert.IsTrue(_ruleDeserialized.Check(new Object()));
            Assert.IsFalse(_ruleDeserialized.Check(null));
        }
    }
}
