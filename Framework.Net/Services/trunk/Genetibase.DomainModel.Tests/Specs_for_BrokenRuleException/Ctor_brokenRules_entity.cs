/* ------------------------------------------------
 * Ctor_brokenRules_entity.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Linq;
using Genetibase.DomainModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Specs_for_BrokenRuleException
{
    [TestClass]
    public sealed class Ctor_brokenRules_entity
    {
        private List<Rule<Object>> _brokenRules;
        private Object _entity;
        private BrokenRuleException<Object> _exception;

        public Ctor_brokenRules_entity()
        {
            _brokenRules = new List<Rule<Object>>(new[] { new Rule<Object>(o => o != null, "o != null") });
            _entity = new Object();
            _exception = new BrokenRuleException<Object>(_brokenRules, _entity);
        }

        [TestMethod]
        public void fills_BrokenRules()
        {
            Assert.AreEqual(1, _exception.BrokenRules.Count());
        }

        [TestMethod]
        public void leaves_InnerException_null()
        {
            Assert.IsNull(_exception.InnerException);
        }

        [TestMethod]
        public void sets_Entity()
        {
            Assert.AreEqual(_entity, _exception.Entity);
        }

        [TestMethod]
        public void sets_Message()
        {
            Assert.IsFalse(String.IsNullOrEmpty(_exception.Message));
        }
    }
}
