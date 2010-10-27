using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Repositories;
using Yogomee.Services.Decorators;
using Yogomee.Services.Storage;

namespace Specs_for_MemberDecorator
{
    [TestClass]
    public sealed class When_creating_member
    {
        private static IUnitOfWork _unitOfWork;
        private static IMemberRepository _repository;
        private static IMemberFactory _factory;

        private static MemberDecorator _decorator;
        
        private static String _email;
        private static Member _member;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _factory = new MemberFactory();
            _repository = _unitOfWork.MemberRepository;
            _decorator = new MemberDecorator(_factory, _repository);

            _email = "test@test.com";
            _member = _decorator.CreateMember(_email);
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Close();
        }
        
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_email_is_null()
        {
            _decorator.CreateMember(null);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_email_is_empty_string()
        {
            _decorator.CreateMember("");
        }

        [TestMethod]
        public void returns_not_null_member()
        {
            Assert.IsNotNull(_member);
        }

        [TestMethod]
        public void set_email()
        {
            Assert.AreEqual(_email, _member.Email);
        }

        [TestMethod]
        public void Password_is_not_null()
        {
            Assert.IsNotNull(_member.Password);
        }

        [TestMethod]
        public void Created_is_not_null()
        {
            Assert.IsNotNull(_member.Created);
        }
    }
}
