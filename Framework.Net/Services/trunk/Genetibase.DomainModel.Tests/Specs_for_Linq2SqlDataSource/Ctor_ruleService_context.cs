/* ------------------------------------------------
 * Ctor_ruleService_context.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Data.Linq;
using Genetibase.DomainModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace Specs_for_Linq2SqlDataSource
{
    [TestClass]
    public sealed class Ctor_ruleService_context
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_context_is_null()
        {
            new Linq2SqlDataSource<Object>(new Mock<IRuleService>().Object, (DataContext)null);
        }
    }
}
