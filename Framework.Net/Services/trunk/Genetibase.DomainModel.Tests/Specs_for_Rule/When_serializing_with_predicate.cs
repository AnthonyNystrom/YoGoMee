/* ------------------------------------------------
 * When_serializing_with_predicate.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;

namespace Specs_for_Rule
{
    [TestClass]
    public sealed class When_serializing_with_predicate
    {
        private Rule<Object> _rule;
        private Rule<Object> _ruleDeserialized;

        public When_serializing_with_predicate()
        {
            _rule = new Rule<Object>(o => o != null);
            _ruleDeserialized = _rule.SerializeDeserialize();
        }

        [TestMethod]
        public void Message_stays_null()
        {
            Assert.IsNull(_ruleDeserialized.Message);
        }

        [TestMethod]
        public void Predicate_is_persisted()
        {
            Assert.IsTrue(_ruleDeserialized.Check(new Object()));
            Assert.IsFalse(_ruleDeserialized.Check(null));
        }
    }
}
