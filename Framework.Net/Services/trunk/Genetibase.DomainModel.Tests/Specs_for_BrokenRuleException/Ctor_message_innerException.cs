/* ------------------------------------------------
 * Ctor_message_innerException.cs
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
    public sealed class Ctor_message_innerException
    {
        private Exception _innerException;
        private BrokenRuleException<Object> _exception;

        public Ctor_message_innerException()
        {
            _innerException = new ArgumentNullException("parameter");
            _exception = new BrokenRuleException<Object>("message", _innerException);
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
        public void sets_InnerException()
        {
            Assert.AreEqual(_innerException, _exception.InnerException);
        }

        [TestMethod]
        public void sets_Message()
        {
            Assert.AreEqual("message", _exception.Message);
        }
    }
}
