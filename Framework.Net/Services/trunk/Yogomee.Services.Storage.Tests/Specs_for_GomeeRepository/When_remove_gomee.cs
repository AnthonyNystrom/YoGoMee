using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.Storage;

namespace Specs_for_GomeeRepository
{
    [TestClass]
    public class When_remove_gomee
    {
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;

        private static Member _member;
        private static Gomee _gomee;
        private static Gomee _loadedGomee;
        private static Int32 _oldCount;
        private static Int32 _newCount;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();

            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            _gomee = _gomeeFactory.CreateGomee(_member);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.GomeeRepository.Add(_gomee);
                uow.PersistAll();
                _oldCount = uow.GomeeRepository.Count();
            }

            using (var uow = new UnitOfWork())
            {
                uow.GomeeRepository.Remove(uow.GomeeRepository.Get(_gomee.Id));
                uow.PersistAll();

                _newCount = uow.GomeeRepository.Count();

                try
                {
                    _loadedGomee = uow.GomeeRepository.Get(_gomee.Id);
                }
                catch (ArgumentException)
                {
                    _loadedGomee = null;
                }
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_gomee_is_null()
        {
            using (var uof = new UnitOfWork())
            {
                uof.GomeeRepository.Remove(null);
            }
        }

        [TestMethod]
        public void gomees_count_decrease()
        {
            Assert.AreEqual(_oldCount - 1, _newCount);
        }

        [TestMethod]
        public void can_not_get_removed_gomee()
        {
            Assert.IsNull(_loadedGomee);
        }
    }
}
