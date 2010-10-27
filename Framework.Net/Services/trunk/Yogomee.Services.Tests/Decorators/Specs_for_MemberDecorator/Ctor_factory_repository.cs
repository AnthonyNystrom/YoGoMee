using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.Decorators;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.Storage;
using Yogomee.Services.DomainModel.Repositories;

namespace Specs_for_MemberDecorator
{
    [TestClass]
    public sealed class Ctor_repository
    {
        private static IUnitOfWork _unitOfWork;

        private static IMemberRepository _repository;
        private static IMemberFactory _factory;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _repository = _unitOfWork.MemberRepository;
            _factory = new MemberFactory();
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_when_MemberFactory_is_null()
        {
            new MemberDecorator(null, _repository);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_when_MemberRepository_is_null()
        {
            new MemberDecorator(_factory, null);
        }
    }
}
