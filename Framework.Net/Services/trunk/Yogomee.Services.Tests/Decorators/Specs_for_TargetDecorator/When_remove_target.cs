using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.Decorators;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;

namespace Specs_for_TargetDecorator
{
    [TestClass]
    public sealed class When_remove_target
    {
        private static ITargetDecorator _targetDecorator;

        private static IUnitOfWork _unitOfWork;
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;
        private static ITargetFactory _targetFactory;

        private static Member _member;
        private static Gomee _gomee;
        private static Target _target;
        private static Target _loadedTarget;

        private static Int32 _oldCount;
        private static Int32 _newCount;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _targetFactory = new TargetFactory();
            _targetDecorator = new TargetDecorator(_targetFactory, _unitOfWork.TargetRepository);

            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            _gomee = _gomeeFactory.CreateGomee(_member);
            _target = _targetFactory.CreateGomeeTarget(_member, _gomee);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.GomeeRepository.Add(_gomee);
                uow.TargetRepository.Add(_target);
                uow.PersistAll();
                _oldCount = uow.TargetRepository.Count();
            }


            _targetDecorator.Remove(_unitOfWork.TargetRepository.Get(_target.Id));
            _unitOfWork.PersistAll();

            _newCount = _unitOfWork.TargetRepository.Count();

            try
            {
                _loadedTarget = _unitOfWork.TargetRepository.Get(_target.Id);
            }
            catch (ArgumentException)
            {
                _loadedTarget = null;
            }

        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                uow.GomeeRepository.Remove(uow.GomeeRepository.Get(_gomee.Id));
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();
            }

            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_target_is_null()
        {
            _targetDecorator.Remove(null);
        }

        [TestMethod]
        public void targets_count_decrease()
        {
            Assert.AreEqual(_oldCount - 1, _newCount);
        }

        [TestMethod]
        public void can_not_get_removed_target()
        {
            Assert.IsNull(_loadedTarget);
        }
    }
}
