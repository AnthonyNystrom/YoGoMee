using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;

namespace Specs_for_MemberRepository
{
    [TestClass]
    public sealed class When_get_member_by_email
    {
        private static IMemberFactory _memberFactory;

        private static Member _member;
        private static Member _loadedMember;

        private static String _email;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();

            _email = Guid.NewGuid().ToString();
            _member = _memberFactory.CreateMember(_email);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            {
                _loadedMember = uow.MemberRepository.Get(_email);
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
        public void throws_ArgumentNullException_when_email_is_null()
        {
            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Get((String)null);
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException))]
        public void throws_ArgumentException_when_member_not_exist()
        {
            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Get("member not exists email");
            }
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_loadedMember);
        }

        [TestMethod]
        public void has_actual_Id()
        {
            Assert.AreEqual(_member.Id, _loadedMember.Id);
        }

        [TestMethod]
        public void has_actual_Email()
        {
            Assert.AreEqual(_member.Email, _loadedMember.Email);
        }

        [TestMethod]
        public void has_actual_Password()
        {
            Assert.AreEqual(_member.Password, _loadedMember.Password);
        }

        [TestMethod]
        public void has_actual_Version()
        {
            Assert.AreEqual(_member.Version, _loadedMember.Version);
        }

        [TestMethod]
        public void has_actual_Created()
        {
            Assert.AreEqual(_member.Created.Year, _loadedMember.Created.Year);
            Assert.AreEqual(_member.Created.Month, _loadedMember.Created.Month);
            Assert.AreEqual(_member.Created.Day, _loadedMember.Created.Day);
            Assert.AreEqual(_member.Created.Hour, _loadedMember.Created.Hour);
            Assert.AreEqual(_member.Created.Minute, _loadedMember.Created.Minute);
            Assert.AreEqual(_member.Created.Second, _loadedMember.Created.Second);
        }   
    }
}
