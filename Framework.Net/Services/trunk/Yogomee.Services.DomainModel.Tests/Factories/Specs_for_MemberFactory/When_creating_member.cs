using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;

namespace Specs_for_MemberFactory
{
    [TestClass]
    public sealed class When_creating_member
    {
        private MemberFactory _memberFactory;
        private String _email;
        private Member _member;

        public When_creating_member()
        {
            _memberFactory = new MemberFactory();
            _email = "test@test.com";
            _member = _memberFactory.CreateMember(_email);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_email_is_null()
        {
            _memberFactory.CreateMember(null);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_email_is_empty_string()
        {
            _memberFactory.CreateMember("");
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
