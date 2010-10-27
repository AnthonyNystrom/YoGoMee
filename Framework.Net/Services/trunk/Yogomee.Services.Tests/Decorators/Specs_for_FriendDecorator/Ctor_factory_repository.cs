using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Repositories;
using Yogomee.Services.Storage;
using Yogomee.Services.Decorators;

namespace Specs_for_FriendDecorator
{
    [TestClass]
    public sealed class Ctor_factory_repository
    {
        private static IUnitOfWork _unitOfWork;

        private static IFriendRepository _repository;
        private static IFriendFactory _factory;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _repository = _unitOfWork.FriendRepository;
            _factory = new FriendFactory();
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_when_FriendFactory_is_null()
        {
            new FriendDecorator(null, _repository);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_when_FriendRepository_is_null()
        {
            new FriendDecorator(_factory, null);
        }
    }
}
