using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;

namespace Specs_for_TargetRepository
{
    [TestClass]
    public class When_get_gomeeTarget
    {
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;
        private static ITargetFactory _targetFactory;

        private static Member _member;
        private static Gomee _gomee;
        private static Target _target;
        private static Target _loadedTarget;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _targetFactory = new TargetFactory();

            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            _gomee = _gomeeFactory.CreateGomee(_member);
            _target = _targetFactory.CreateGomeeTarget(_member, _gomee);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.GomeeRepository.Add(_gomee);
                uow.TargetRepository.Add(_target);
                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            {
                _loadedTarget = uow.TargetRepository.Get(_target.Id);
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                uow.TargetRepository.Remove(uow.TargetRepository.Get(_target.Id));
                uow.GomeeRepository.Remove(uow.GomeeRepository.Get(_gomee.Id));
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException))]
        public void throws_ArgumentException_when_target_not_exist()
        {
            using (var uow = new UnitOfWork())
            {
                uow.TargetRepository.Get(0);
            }
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_loadedTarget);
        }

        [TestMethod]
        public void has_actual_Id()
        {
            Assert.AreEqual(_target.Id, _loadedTarget.Id);
        }

        [TestMethod]
        public void has_actual_Member()
        {
            Assert.AreEqual(_target.Member.Id, _loadedTarget.Member.Id);
        }

        [TestMethod]
        public void has_actual_Gomee()
        {
            Assert.AreEqual(_target.Gomee.Id, _loadedTarget.Gomee.Id);
        }
    }
}
