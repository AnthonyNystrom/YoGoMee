/* ------------------------------------------------
 * When_serializing.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;
using Genetibase.DomainModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Specs_for_BrokenRuleException
{
    [TestClass]
    public sealed class When_serializing
    {
        private BrokenRuleException<Object> _exception;

        public When_serializing()
        {
            _exception = new BrokenRuleException<Object>();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Ctor_checks_if_info_is_null()
        {
            new BrokenRuleException<Object>((SerializationInfo)null, new StreamingContext());
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void GetObjectData_checks_if_info_is_null()
        {
            _exception.GetObjectData(null, new StreamingContext());
        }
    }
}
