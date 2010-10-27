using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Repositories;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.Storage;
using Yogomee.Services.DomainModel.Entities;

namespace Specs_for_MemberRepository
{
    [TestClass]
    public class When_add_member
    {
        private static IMemberFactory _memberFactory;

        private static String _email;
        private static Member _member;
        private static Member _loadedMember;
        private static Int32 _oldCount;
        private static Int32 _newCount;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();

            _email = Guid.NewGuid().ToString();

            using (var uow = new UnitOfWork())
            {
                _oldCount = uow.MemberRepository.Count();
                _member = _memberFactory.CreateMember(_email);
                uow.MemberRepository.Add(_member);
                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            {
                _newCount = uow.MemberRepository.Count();
                try
                {
                    _loadedMember = uow.MemberRepository.Get(_member.Id);
                }
                catch (Exception)
                {
                    _loadedMember = null;
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
        public void throws_ArgumentNullException_if_member_is_null()
        {
            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(null);
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException))]
        public void throws_ArgumentException_if_member_with_specified_email_exist()
        {
            using (var uow = new UnitOfWork())
            {
                var member = _memberFactory.CreateMember(_email);
                uow.MemberRepository.Add(member);
            }
        }

        [TestMethod]
        public void member_count_increase()
        {
            Assert.AreEqual(_oldCount + 1, _newCount);
        }

        [TestMethod]
        public void added_member_exist()
        {
            Assert.IsNotNull(_loadedMember);
        }
    }
}
