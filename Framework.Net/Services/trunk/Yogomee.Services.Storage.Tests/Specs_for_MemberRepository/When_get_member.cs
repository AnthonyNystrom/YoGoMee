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
    public class When_get_member
    {
        private static IMemberFactory _memberFactory;
        
        private static Member _member;
        private static Member _loadedMember;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        { 
            _memberFactory = new MemberFactory();

            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            
            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            {
                _loadedMember = uow.MemberRepository.Get(_member.Id);
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
        [ExpectedException(typeof(ArgumentException))]
        public void throws_ArgumentException_when_member_not_exist()
        {
            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Get(0);
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
