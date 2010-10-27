using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;
using Yogomee.Services.Decorators;
using Yogomee.Services.DomainModel;

namespace Specs_for_GomeeDecorator
{
    [TestClass]
    public sealed class When_get_mine_gomees
    {
        private static IGomeeDecorator _gomeeDecorator;

        private static IUnitOfWork _unitOfWork;
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;

        private static Member _member;
        private static List<Gomee> _gomees;

        private static IEnumerable<Gomee> _mineGomees;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _gomeeDecorator = new GomeeDecorator(_gomeeFactory, _unitOfWork.GomeeRepository);

            using (var uow = new UnitOfWork())
            {
                _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
                uow.MemberRepository.Add(_member);

                _gomees = new List<Gomee>();
                var count = new Random().Next(2, 10);
                for (var i = 0; i < count; i++)
                {
                    var gomee = _gomeeFactory.CreateGomee(_member);
                    _gomees.Add(gomee);
                    uow.GomeeRepository.Add(gomee);
                }

                uow.PersistAll();
            }

            _mineGomees = _gomeeDecorator.GetMineFor(_unitOfWork.MemberRepository.Get(_member.Id));
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                foreach (var gomee in _gomees)
                {
                    uow.GomeeRepository.Remove(uow.GomeeRepository.Get(gomee.Id));
                }
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();
            }

            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_member_is_null()
        {
            _gomeeDecorator.GetMineFor(null);
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_mineGomees);
        }

        [TestMethod]
        public void returned_enumerable_has_actual_count()
        {
            Assert.AreEqual(_gomees.Count(), _mineGomees.Count());
        }

        [TestMethod]
        public void returned_enumerable_has_actual_gomees()
        {
            foreach (var gomee in _mineGomees)
            {
                Assert.AreEqual(1, _gomees.Where(g => g.Id == gomee.Id).Count());
            }
        }
    }
}
