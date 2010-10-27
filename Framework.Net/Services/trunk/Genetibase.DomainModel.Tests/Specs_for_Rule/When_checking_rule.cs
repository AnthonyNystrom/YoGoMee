/* ------------------------------------------------
 * When_checking_rule.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Specs_for_Rule
{
    [TestClass]
    public sealed class When_checking_rule
    {
        private Rule<FakeEntity> _rule;
        public FakeEntity _entity;

        public When_checking_rule()
        {
            _rule = new Rule<FakeEntity>(e => e.PropertyFake <= 10);
            _entity = new FakeEntity();
        }

        [TestMethod]
        public void returns_false_if_entity_is_invalid()
        {
            _entity.PropertyFake = 11;
            Assert.IsFalse(_rule.Check(_entity));
        }

        [TestMethod]
        public void returns_true_if_entity_is_valid()
        {
            _entity.PropertyFake = 8;
            Assert.IsTrue(_rule.Check(_entity));
        }
    }
}
