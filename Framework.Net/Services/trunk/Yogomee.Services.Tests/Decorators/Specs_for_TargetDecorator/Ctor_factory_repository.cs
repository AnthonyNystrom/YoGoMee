using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Repositories;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.Storage;
using Yogomee.Services.Decorators;

namespace Specs_for_TargetDecorator
{
    [TestClass]
    public class Ctor_factory_repository
    {
        private static IUnitOfWork _unitOfWork;

        private static ITargetRepository _repository;
        private static ITargetFactory _factory;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _repository = _unitOfWork.TargetRepository;
            _factory = new TargetFactory();
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
            new TargetDecorator(null, _repository);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_when_FriendRepository_is_null()
        {
            new TargetDecorator(_factory, null);
        }
    }
}
