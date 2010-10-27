using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Decorators;
using Yogomee.Services.DomainModel;
using Yogomee.Services.Storage;

namespace Specs_for_GomeeDecorator
{
    [TestClass]
    public sealed class When_creating_gomee
    {
        private static IGomeeDecorator _gomeeDecorator;

        private static IUnitOfWork _unitOfWork;
        private static IMemberFactory _memberFactory;
        private static Member _member;

        private static GomeeFactory _gomeeFactory;
        private static Gomee _gomee;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _gomeeDecorator = new GomeeDecorator(_gomeeFactory, _unitOfWork.GomeeRepository);

            _member = _memberFactory.CreateMember("test@test.com");

            _gomee = _gomeeDecorator.CreateGomee(_member);
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_member_is_null()
        {
            _gomeeDecorator.CreateGomee(null);
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_gomee);
        }

        [TestMethod]
        public void set_Member()
        {
            Assert.AreEqual(_member, _gomee.Member);
        }

        [TestMethod]
        public void Caption_is_not_null()
        {
            Assert.IsNotNull(_gomee.Caption);
        }

        [TestMethod]
        public void Address_is_not_null()
        {
            Assert.IsNotNull(_gomee.Address);
        }

        [TestMethod]
        public void Description_is_not_null()
        {
            Assert.IsNotNull(_gomee.Description);
        }

        [TestMethod]
        public void Created_is_not_null()
        {
            Assert.IsNotNull(_gomee.Created);
        }
    }
}
