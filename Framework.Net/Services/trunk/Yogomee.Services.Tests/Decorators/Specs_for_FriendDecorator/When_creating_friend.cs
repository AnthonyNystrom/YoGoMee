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

namespace Specs_for_FriendDecorator
{
    [TestClass]
    public sealed class When_creating_friend
    {
        private static IUnitOfWork _unitOfWork;
        private static IMemberDecorator _memberDecorator;
        private static IFriendDecorator _friendDecorator;
    
        private static Member _member1;
        private static Member _member2;

        private static Friend _friend;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _memberDecorator = new MemberDecorator(new MemberFactory(), _unitOfWork.MemberRepository);
            _friendDecorator = new FriendDecorator(new FriendFactory(), _unitOfWork.FriendRepository);

            _member1 = _memberDecorator.CreateMember("member1@test.com");
            _member2 = _memberDecorator.CreateMember("member2@test.com");

            _friend = _friendDecorator.CreateFriend(_member1, _member2);
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_member1_is_null()
        {
            _friendDecorator.CreateFriend(null, _member2);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_member2_is_null()
        {
            _friendDecorator.CreateFriend(_member1, null);
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
