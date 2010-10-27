/* ------------------------------------------------
 * Ctor_ruleService_identityPropertyName.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace Specs_for_MemoryDataSource
{
    [TestClass]
    public sealed class Ctor_ruleService_identityPropertyName
    {
        private IRuleService _ruleService;

        public Ctor_ruleService_identityPropertyName()
        {
            _ruleService = new Mock<IRuleService>().Object;
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_ruleService_is_null()
        {
            new MemoryDataSource<FakeEntity>(null, "Id");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_identityPropertyName_is_empty()
        {
            new MemoryDataSource<FakeEntity>(_ruleService, "");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_identityPropertyName_is_null()
        {
            new MemoryDataSource<FakeEntity>(_ruleService, null);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException))]
        public void checks_if_identityProperty_exists()
        {
            new MemoryDataSource<FakeEntity>(_ruleService, "SomePropertyThatDoesNotExist");
        }
    }
}
