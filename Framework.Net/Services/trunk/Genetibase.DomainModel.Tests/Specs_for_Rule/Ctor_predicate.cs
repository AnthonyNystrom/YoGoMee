/* ------------------------------------------------
 * Ctor_predicate.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Specs_for_Rule
{
    [TestClass]
    public sealed class Ctor_predicate
    {
        private Rule<FakeEntity> _rule;

        public Ctor_predicate()
        {
            _rule = new Rule<FakeEntity>(e => e.PropertyFake <= 10);
        }

        [TestMethod]
        public void leaves_Message_null()
        {
            Assert.IsNull(_rule.Message);
        }
    }
}
