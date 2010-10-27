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
    public sealed class When_remove_gomee
    {
        private static IGomeeDecorator _gomeeDecorator;

        private static IUnitOfWork _unitOfWork;
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
            _unitOfWork = new UnitOfWork();
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _gomeeDecorator = new GomeeDecorator(_gomeeFactory, _unitOfWork.GomeeRepository);

            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            _gomee = _gomeeFactory.CreateGomee(_member);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.GomeeRepository.Add(_gomee);
                uow.PersistAll();
                _oldCount = uow.GomeeRepository.Count();
            }


            _gomeeDecorator.Remove(_unitOfWork.GomeeRepository.Get(_gomee.Id));
            _unitOfWork.PersistAll();

            _newCount = _unitOfWork.GomeeRepository.Count();

            try
            {
                _loadedGomee = _unitOfWork.GomeeRepository.Get(_gomee.Id);
            }
            catch (ArgumentException)
            {
                _loadedGomee = null;
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

            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_gomee_is_null()
        {

            _gomeeDecorator.Remove(null);
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
