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

namespace Specs_for_TargetDecorator
{
    [TestClass]
    public sealed class When_creating_target
    {
        private static ITargetDecorator _targetDecorator;

        private static IUnitOfWork _unitOfWork;
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;

        private static TargetFactory _targetFactory;

        private static Member _member;
        private static Gomee _gomee;
        private static Target _target;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _targetFactory = new TargetFactory();
            _targetDecorator = new TargetDecorator(_targetFactory, _unitOfWork.TargetRepository);

            _member = _memberFactory.CreateMember("test@test.com");
            _gomee = _gomeeFactory.CreateGomee(_member);

            _target = _targetDecorator.CreateTarget(_member, _gomee);
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_member_is_null()
        {
            _targetDecorator.CreateTarget(null, _gomee);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_gomee_is_null()
        {
            _targetDecorator.CreateTarget(_member, null);
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_target);
        }

        [TestMethod]
        public void set_member()
        {
            Assert.AreEqual(_member, _target.Member);
        }

        [TestMethod]
        public void set_gomee()
        {
            Assert.AreEqual(_gomee, _target.Gomee);
        }

        [TestMethod]
        public void Created_is_not_null()
        {
            Assert.IsNotNull(_target.Created);
        }   
    }
}
