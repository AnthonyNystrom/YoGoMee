using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel;
using Yogomee.Services.Decorators;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;

namespace Specs_for_MemberDecorator
{
    [TestClass]
    public class When_remove_member
    {
        private static IUnitOfWork _unitOfWork;
        private static IMemberFactory _factory;

        private static MemberDecorator _decorator;

        private static Member _member;
        private static Member _loadedMember;
        private static Int32 _oldCount;
        private static Int32 _newCount;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _factory = new MemberFactory();
            _decorator = new MemberDecorator(_factory, _unitOfWork.MemberRepository);

            _member = _factory.CreateMember(Guid.NewGuid().ToString());

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.PersistAll();

                _oldCount = uow.MemberRepository.Count();
            }

            _decorator.Remove(_unitOfWork.MemberRepository.Get(_member.Id));
            _unitOfWork.PersistAll();

            _newCount = _unitOfWork.MemberRepository.Count();

            try
            {
                _loadedMember = _unitOfWork.MemberRepository.Get(_member.Id);
            }
            catch (ArgumentException)
            {
                _loadedMember = null;
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throwsArgumentNullException_if_member_is_null()
        {
            _decorator.Remove(null);
        }

        [TestMethod]
        public void members_count_decrease()
        {
            Assert.AreEqual(_oldCount - 1, _newCount);
        }

        [TestMethod]
        public void removed_member_not_exist()
        {
            Assert.IsNull(_loadedMember);
        }
    }
}
