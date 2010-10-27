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
    public sealed class When_remove_friend
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
                uow.MemberRepository.Add(_member1);
                uow.MemberRepository.Add(_member2);

                uow.FriendRepository.Add(_friend);

                uow.PersistAll();
                _oldCount = uow.FriendRepository.Count();
            }

            using (var uow = new UnitOfWork())
            {
                uow.FriendRepository.Remove(uow.FriendRepository.Get(_friend.Id));
                uow.PersistAll();

                _newCount = uow.FriendRepository.Count();

                try
                {
                    _loadedFriend = uow.FriendRepository.Get(_friend.Id);
                }
                catch (ArgumentException)
                {
                    _loadedFriend = null;
                }
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
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
                uof.FriendRepository.Remove(null);
            }
        }

        [TestMethod]
        public void friends_count_decrease()
        {
            Assert.AreEqual(_oldCount - 1, _newCount);
        }

        [TestMethod]
        public void can_not_get_removed_friend()
        {
            Assert.IsNull(_loadedFriend);
        }
    }
}
