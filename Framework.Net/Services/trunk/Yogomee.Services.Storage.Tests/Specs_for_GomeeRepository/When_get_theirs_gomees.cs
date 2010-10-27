using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.Storage;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Repositories;
using Yogomee.Services.DomainModel.Factories;

namespace Specs_for_GomeeRepository
{
    [TestClass]
    public class When_get_theirs_gomees
    {
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;
        private static ITargetFactory _gomeeTargetFactory;

        private static Member _me;
        private static Member _he;

        private static IEnumerable<Gomee> _loadedGomees;
        private static List<Gomee> _hisGomees;
        private static List<Gomee> _mineGomees;
        private static List<Target> _targets;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _gomeeTargetFactory = new TargetFactory();

            using (var uow = new UnitOfWork())
            {
                _me = _memberFactory.CreateMember(Guid.NewGuid().ToString());
                _he = _memberFactory.CreateMember(Guid.NewGuid().ToString());

                uow.MemberRepository.Add(_me);
                uow.MemberRepository.Add(_he);

                _hisGomees = new List<Gomee>();
                _mineGomees = new List<Gomee>();
                _targets = new List<Target>();

                var count = new Random().Next(2, 5);
                for (var i = 0; i < count; i++)
                {
                    var mineGomee = _gomeeFactory.CreateGomee(_me);
                    var mineTarget = _gomeeTargetFactory.CreateGomeeTarget(_me, mineGomee);
                    var hisGome = _gomeeFactory.CreateGomee(_he);
                    var hisTarget1 = _gomeeTargetFactory.CreateGomeeTarget(_me, hisGome);
                    var hisTarget2 = _gomeeTargetFactory.CreateGomeeTarget(_me, hisGome);

                    _mineGomees.Add(mineGomee);
                    _hisGomees.Add(hisGome);
                    _targets.Add(mineTarget);
                    _targets.Add(hisTarget1);
                    _targets.Add(hisTarget2);

                    uow.GomeeRepository.Add(mineGomee);
                    uow.GomeeRepository.Add(hisGome);
                    uow.TargetRepository.Add(mineTarget);
                    uow.TargetRepository.Add(hisTarget1);
                    uow.TargetRepository.Add(hisTarget2);
                }

                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            { 
                var member = uow.MemberRepository.Get(_me.Id);
                _loadedGomees = uow.GomeeRepository.GetTheirsFor(member);
            }
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

                foreach (var gomee in _mineGomees)
                {
                    uow.GomeeRepository.Remove(uow.GomeeRepository.Get(gomee.Id));
                }

                foreach (var gomee in _hisGomees)
                {
                    uow.GomeeRepository.Remove(uow.GomeeRepository.Get(gomee.Id));
                }

                uow.MemberRepository.Remove(uow.MemberRepository.Get(_me.Id));
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_he.Id));

                uow.PersistAll();
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_member_is_null()
        {
            using (var uow = new UnitOfWork())
            {
                uow.GomeeRepository.GetTheirsFor(null);
            }
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_loadedGomees);
        }

        [TestMethod]
        public void returned_enumerable_has_actual_count()
        {
            Assert.AreEqual(_hisGomees.Count(), _loadedGomees.Count());
        }

        [TestMethod]
        public void returned_enumerable_has_actual_gomees()
        {
            foreach (var gomee in _loadedGomees)
            {
                Assert.AreEqual(1, _hisGomees.Where(g => g.Id == gomee.Id).Count());
            }
        }
    }
}
