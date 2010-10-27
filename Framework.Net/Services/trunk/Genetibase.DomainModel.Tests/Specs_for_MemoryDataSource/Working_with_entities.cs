/* ------------------------------------------------
 * Working_with_entities.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Linq;
using Genetibase.DomainModel;
using Genetibase.DomainModel.Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;

namespace Specs_for_MemoryDataSource
{
    [TestClass]
    public sealed class Working_with_entities
    {
        private IDataSource<FakeEntity> _dataSource;

        public Working_with_entities()
        {
            _dataSource = new MemoryDataSource<FakeEntity>(new Mock<IRuleService>().Object, "Id");
        }

        [TestMethod]
        public void can_add_entity()
        {
            var entity = new FakeEntity();
            _dataSource.Add(entity);
            Assert.AreEqual(entity, _dataSource.Last());
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Add_checks_if_entity_is_null()
        {
            _dataSource.Add(null);
        }

        [TestMethod]
        public void every_entity_has_unique_identity()
        {
            var entity = new FakeEntity();
            var otherEntity = new FakeEntity();

            _dataSource.Add(entity);
            _dataSource.Add(otherEntity);

            Assert.AreNotEqual(entity.Id, otherEntity.Id);
        }

        [TestMethod]
        public void Remove_returns_false_if_null_is_passed()
        {
            Assert.IsFalse(_dataSource.Remove(null));
        }
    }
}
