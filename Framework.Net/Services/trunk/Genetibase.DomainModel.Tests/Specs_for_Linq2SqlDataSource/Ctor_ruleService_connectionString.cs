/* ------------------------------------------------
 * Ctor_ruleService_connectionString.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace Specs_for_Linq2SqlDataSource
{
    [TestClass]
    public sealed class Ctor_ruleService_connectionString
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_ruleService_is_null()
        {
            new Linq2SqlDataSource<Object>(null, "some string");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_connectionString_empty()
        {
            new Linq2SqlDataSource<FakeEntity>(new Mock<IRuleService>().Object, "");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_connectionString_is_null()
        {
            new Linq2SqlDataSource<FakeEntity>(new Mock<IRuleService>().Object, (String)null);
        }
    }
}
