using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel;
using Yogomee.Services.Decorators;
using Yogomee.Services.Storage;

namespace Specs_for_GomeeDecorator
{
    [TestClass]
    public sealed class When_add_gomee
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


            _oldCount = _unitOfWork.GomeeRepository.Count();
            _unitOfWork.MemberRepository.Add(_member);
            _gomeeDecorator.Add(_gomee);
            _unitOfWork.PersistAll();


            using (var uow = new UnitOfWork())
            {
                _newCount = uow.GomeeRepository.Count();
                _loadedGomee = uow.GomeeRepository.Get(_gomee.Id);
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
        public void throws_ArgumentNullException_if_gomee_is_null()
        {
            _gomeeDecorator.Add(null);
        }

        [TestMethod]
        public void gomees_count_increase()
        {
            Assert.AreEqual(_oldCount + 1, _newCount);
        }

        [TestMethod]
        public void added_gomee_exist()
        {
            Assert.IsNotNull(_loadedGomee);
        }
    }
}
