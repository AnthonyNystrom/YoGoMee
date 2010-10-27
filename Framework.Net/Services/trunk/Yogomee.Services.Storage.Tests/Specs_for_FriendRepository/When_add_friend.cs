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
    public sealed class When_add_friend
    {
        private static IMemberFactory _memberFactory;
        private static IFriendFactory _friendFactory;

        private static Member _member1;
        private static Member _member2;

        private static Friend _friend;
        private static Friend _loadedFriend;
        private static Int32 _oldCount;
        private static Int32 _newCount;

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
                _oldCount = uow.FriendRepository.Count();
                uow.MemberRepository.Add(_member1);
                uow.MemberRepository.Add(_member2);
                uow.FriendRepository.Add(_friend);
                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            {
                _newCount = uow.FriendRepository.Count();
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
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_friend_is_null()
        {
            using (var uof = new UnitOfWork())
            {
                uof.FriendRepository.Add(null);
            }
        }

        [TestMethod]
        public void friends_count_increase()
        {
            Assert.AreEqual(_oldCount + 1, _newCount);
        }

        [TestMethod]
        public void added_friend_exist()
        {
            Assert.IsNotNull(_loadedFriend);
        }
    }
}
