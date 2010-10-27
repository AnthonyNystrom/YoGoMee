/* ------------------------------------------------
 * Working_with_rules.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;

namespace Specs_for_RuleService
{
    [TestClass]
    public sealed class Working_with_rules
    {
        private IRuleService _rp;

        [TestInitialize]
        public void SetUp()
        {
            _rp = new RuleService();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void AddRule_checks_if_rule_is_null()
        {
            _rp.AddRule<Object>(null);
        }

        [TestMethod]
        public void GetRules_returns_empty_collection_if_no_rules_for_type()
        {
            Assert.AreEqual(0, _rp.GetRules<FakeEntity>().Count());
        }

        [TestMethod]
        public void CollectBrokenRules_checks_associated_rules_against_specified_entity()
        {
            _rp.AddRule<FakeEntity>(new Rule<FakeEntity>(e => e.PropertyFake <= 10));
            _rp.AddRule<FakeEntity>(new Rule<FakeEntity>(e => e.PropertyFake >= 5));
            var rules = _rp.GetRules<FakeEntity>();
            var entity = new FakeEntity();
            entity.PropertyFake = 11;

            var brokenRules = _rp.CollectBrokenRules<FakeEntity>(entity);
            Assert.AreEqual(1, brokenRules.Count());
        }

        [TestMethod]
        public void CollectBrokenRules_returns_empty_collection_if_no_rules_for_type()
        {
            Assert.AreEqual(0, _rp.CollectBrokenRules<Object>(new Object()).Count());
        }

        [TestMethod]
        public void provides_quick_interface_for_adding_rules()
        {
            _rp
                .AddRule(new Rule<FakeEntity>(e => e.PropertyFake <= 10))
                .AddRule(new Rule<FakeEntity>(e => e.PropertyFake >= 5));
            Assert.AreEqual(2, _rp.GetRules<FakeEntity>().Count());
        }

        [TestMethod]
        public void returns_populated_rule_collection_for_type_if_added_previously()
        {
            _rp.AddRule<FakeEntity>(new Rule<FakeEntity>(e => e.PropertyFake <= 10));
            var rules = _rp.GetRules<FakeEntity>();
            Assert.AreEqual(1, rules.Count());
        }
    }
}
