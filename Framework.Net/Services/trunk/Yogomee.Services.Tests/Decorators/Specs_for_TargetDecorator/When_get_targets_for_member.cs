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
    public sealed class When_get_targets_for_member
    {
        private static ITargetDecorator _targetDecorator;

        private static IUnitOfWork _unitOfWork;
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;
        private static ITargetFactory _targetFactory;

        private static Member _member;
        private static Gomee _gomee;

        private static List<Target> _targets;
        private static IEnumerable<Target> _loadedTargets;

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
            _targets = new List<Target>();

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.GomeeRepository.Add(_gomee);

                var count = new Random().Next(2, 5);
                for (var i = 0; i < count; i++)
                {
                    var target = _targetFactory.CreateGomeeTarget(_member, _gomee);
                    _targets.Add(target);
                    uow.TargetRepository.Add(target);
                }

                uow.PersistAll();
            }

            _loadedTargets = _targetDecorator.GetFor(_unitOfWork.MemberRepository.Get(_member.Id));
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                foreach (var target in _targets)
                {
                    uow.TargetRepository.Remove(uow.TargetRepository.Get(target.Id));
                }

                uow.GomeeRepository.Remove(uow.GomeeRepository.Get(_gomee.Id));
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();
            }

            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_member_is_null()
        {
            _targetDecorator.GetFor((Member)null);
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_loadedTargets);
        }

        [TestMethod]
        public void returned_enumerable_has_actual_count()
        {
            Assert.AreEqual(_targets.Count(), _loadedTargets.Count());
        }

        [TestMethod]
        public void returned_enumerable_has_actual_targets()
        {
            foreach (var target in _loadedTargets)
            {
                Assert.AreEqual(1, _targets.Where(t => t.Id == target.Id).Count());
            }
        }
    }
}
