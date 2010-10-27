using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;

namespace Specs_for_FriendRepository
{
    [TestClass]
    public sealed class When_get_friend
    {
        private static IMemberFactory _memberFactory;
        private static IFriendFactory _friendFactory;

        private static Member _member1;
        private static Member _member2;

        private static Friend _friend;
        private static Friend _loadedFriend;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();
            _friendFactory = new FriendFactory();

            _member1 = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            _member2 = _memberFactory.CreateMember(Guid.NewGuid().ToString());

            _friend = _friendFactory.CreateFriend(_member1, _member2);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member1);
                uow.MemberRepository.Add(_member2);

                uow.FriendRepository.Add(_friend);
                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            {
                _loadedFriend = uow.FriendRepository.Get(_friend.Id);
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                uow.FriendRepository.Remove(uow.FriendRepository.Get(_friend.Id));

                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member1.Id));
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member2.Id));
                uow.PersistAll();
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException))]
        public void throws_ArgumentException_when_friend_not_exist()
        {
            using (var uow = new UnitOfWork())
            {
                uow.FriendRepository.Get(0);
            }
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_loadedFriend);
        }

        [TestMethod]
        public void has_actual_Id()
        {
            Assert.AreEqual(_friend.Id, _loadedFriend.Id);
        }

        [TestMethod]
        public void has_actual_Member1()
        {
            Assert.AreEqual(_friend.Member1.Id, _loadedFriend.Member1.Id);
        }

        [TestMethod]
        public void has_actual_Member2()
        {
            Assert.AreEqual(_friend.Member2.Id, _loadedFriend.Member2.Id);
        }

        [TestMethod]
        public void has_actual_Version()
        {
            Assert.AreEqual(_friend.Version, _loadedFriend.Version);
        }

        [TestMethod]
        public void has_actual_Created()
        {
            Assert.AreEqual(_friend.Created.Year, _loadedFriend.Created.Year);
            Assert.AreEqual(_friend.Created.Month, _loadedFriend.Created.Month);
            Assert.AreEqual(_friend.Created.Day, _loadedFriend.Created.Day);
            Assert.AreEqual(_friend.Created.Hour, _loadedFriend.Created.Hour);
            Assert.AreEqual(_friend.Created.Minute, _loadedFriend.Created.Minute);
            Assert.AreEqual(_friend.Created.Second, _loadedFriend.Created.Second);
        }
    }
}
