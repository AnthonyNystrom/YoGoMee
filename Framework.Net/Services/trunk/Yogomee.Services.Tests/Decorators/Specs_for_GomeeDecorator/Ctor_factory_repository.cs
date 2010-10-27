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

namespace Specs_for_GomeeDecorator
{
    [TestClass]
    public sealed class Ctor_factory_repository
    {
        private static IUnitOfWork _unitOfWork;

        private static IGomeeRepository _repository;
        private static IGomeeFactory _factory;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _repository = _unitOfWork.GomeeRepository;
            _factory = new GomeeFactory();
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_when_GomeeFactory_is_null()
        {
            new GomeeDecorator(null, _repository);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_when_GomeeRepository_is_null()
        {
            new GomeeDecorator(_factory, null);
        }
    }
}
