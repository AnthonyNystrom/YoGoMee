/* ------------------------------------------------
 * Ctor_default.cs
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
    public sealed class Ctor_default
    {
        private BrokenRuleException<Object> _exception;

        public Ctor_default()
        {
            _exception = new BrokenRuleException<Object>();
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
        public void leaves_Message_empty()
        {
            Assert.AreEqual("", _exception.Message);
        }
    }
}
