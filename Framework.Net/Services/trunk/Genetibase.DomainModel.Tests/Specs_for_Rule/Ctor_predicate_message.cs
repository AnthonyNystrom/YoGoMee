/* ------------------------------------------------
 * Ctor_predicate_message.cs
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
    public sealed class Ctor_predicate_message
    {
        private const String _msg = "PropertyFake must be <= 10";
        private Rule<FakeEntity> _rule;

        public Ctor_predicate_message()
        {
            _rule = new Rule<FakeEntity>(e => e.PropertyFake <= 10, _msg);
        }

        [TestMethod]
        public void sets_Message()
        {
            Assert.AreEqual(_msg, _rule.Message);
        }
    }
}
