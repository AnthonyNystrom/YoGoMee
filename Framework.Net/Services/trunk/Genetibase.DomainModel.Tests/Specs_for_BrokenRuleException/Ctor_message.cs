/* ------------------------------------------------
 * Ctor_message.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Linq;
using Genetibase.DomainModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Specs_for_BrokenRuleException
{
    [TestClass]
    public sealed class Ctor_message
    {
        private BrokenRuleException<Object> _exception;

        public Ctor_message()
        {
            _exception = new BrokenRuleException<Object>("message");
        }

        [TestMethod]
        public void leaves_BrokenRules_empty()
        {
            Assert.AreEqual(0, _exception.BrokenRules.Count());
        }

        [TestMethod]
        public void leaves_Entity_null()
        {
            Assert.IsNull(_exception.Entity);
        }

        [TestMethod]
        public void leaves_InnerException_null()
        {
            Assert.IsNull(_exception.InnerException);
        }

        [TestMethod]
        public void sets_Message()
        {
            Assert.AreEqual("message", _exception.Message);
        }
    }
}
