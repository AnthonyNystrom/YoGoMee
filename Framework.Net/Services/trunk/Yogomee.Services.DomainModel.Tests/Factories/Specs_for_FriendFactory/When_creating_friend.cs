using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Tests.Factories.Specs_for_FriendFactory
{
    [TestClass]
    public sealed class When_creating_friend
    {
        private static IMemberFactory _memberFactory;
        private static Member _member1;
        private static Member _member2;

        private static FriendFactory _friendFactory;
        private static Friend _friend;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();
            _friendFactory = new FriendFactory();

            _member1 = _memberFactory.CreateMember("member1@test.com");
            _member2 = _memberFactory.CreateMember("member2@test.com");

            _friend = _friendFactory.CreateFriend(_member1, _member2);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_member1_is_null()
        {
            _friendFactory.CreateFriend(null, _member2);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_member2_is_null()
        {
            _friendFactory.CreateFriend(_member1, null);
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_friend);
        }

        [TestMethod]
        public void set_Member1()
        {
            Assert.AreEqual(_member1, _friend.Member1);
        }

        [TestMethod]
        public void set_Member2()
        {
            Assert.AreEqual(_member2, _friend.Member2);
        }

        [TestMethod]
        public void Created_is_not_null()
        {
            Assert.IsNotNull(_friend.Created);
        }
    }
}
