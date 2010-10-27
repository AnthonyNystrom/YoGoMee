using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.Storage;
using Yogomee.Services.DomainModel.Entities;

namespace Specs_for_MemberRepository
{
    [TestClass]
    public class When_remove_member
    {
        private static IMemberFactory _memberFactory;
        
        private static Member _member;
        private static Member _loadedMember;
        private static Int32 _oldCount;
        private static Int32 _newCount;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();

            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            
            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.PersistAll();

                _oldCount = uow.MemberRepository.Count();
            }

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();

                _newCount = uow.MemberRepository.Count();

                try
                {
                    _loadedMember = uow.MemberRepository.Get(_member.Id);
                }
                catch (ArgumentException)
                {
                    _loadedMember = null;
                }
            }      
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throwsArgumentNullException_if_member_is_null()
        {
            using (var uof = new UnitOfWork())
            {
                uof.MemberRepository.Remove(null);
            }
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
