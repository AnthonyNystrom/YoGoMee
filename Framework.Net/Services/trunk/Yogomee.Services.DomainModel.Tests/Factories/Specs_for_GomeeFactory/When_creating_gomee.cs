using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;

namespace Specs_for_GomeeFactory
{
    [TestClass]
    public class When_creating_gomee
    {
        private IMemberFactory _memberFactory;
        private Member _member;

        private GomeeFactory _gomeeFactory;
        private Gomee _gomee;

        public When_creating_gomee()
        {
            _memberFactory = new MemberFactory();
            _member = _memberFactory.CreateMember("test@test.com");

            _gomeeFactory = new GomeeFactory();
            _gomee = _gomeeFactory.CreateGomee(_member);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_member_is_null()
        {
            _gomeeFactory.CreateGomee(null);
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_gomee);
        }

        [TestMethod]
        public void set_Member()
        {
            Assert.AreEqual(_member, _gomee.Member);
        }

        [TestMethod]
        public void Caption_is_not_null()
        {
            Assert.IsNotNull(_gomee.Caption);
        }

        [TestMethod]
        public void Address_is_not_null()
        {
            Assert.IsNotNull(_gomee.Address);
        }

        [TestMethod]
        public void Description_is_not_null()
        {
            Assert.IsNotNull(_gomee.Description);
        }

        [TestMethod]
        public void Created_is_not_null()
        {
            Assert.IsNotNull(_gomee.Created);
        }
    }
}
