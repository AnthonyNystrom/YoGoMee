/* ------------------------------------------------
 * Working_with_Message.cs
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
    public sealed class Working_with_Message
    {
        private const String _msg = "PropertyFake must be <= 10";
        private Rule<FakeEntity> _rule;

        public Working_with_Message()
        {
            _rule = new Rule<FakeEntity>(e => e.PropertyFake <= 10);
        }

        [TestMethod]
        public void default_Message_is_null()
        {
            Assert.IsNull(_rule.Message);
        }

        [TestMethod]
        public void can_set_Message()
        {
            _rule.Message = _msg;
            Assert.AreEqual(_msg, _rule.Message);
        }
    }
}
