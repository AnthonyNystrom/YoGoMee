using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.Storage;

namespace Specs_for_FriendRepository
{
    [TestClass]
    public sealed class When_get_friends_for_member
    {
        private static IMemberFactory _memberFactory;
        private static IFriendFactory _friendFactory;
        
        private static Member _member;

        private static List<Member> _members;
        private static List<Friend> _friends;
        private static IEnumerable<Friend> _loadedFriends;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();
            _friendFactory = new FriendFactory();
            
            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            _members = new List<Member>();
            _friends = new List<Friend>();

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);

                var count = new Random().Next(2, 5);
                for (var i = 0; i < count; i++)
                {
                    var member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
                    var friend = _friendFactory.CreateFriend(_member, member);
                    _friends.Add(friend);
                    _members.Add(member);

                    uow.MemberRepository.Add(member);
                    uow.FriendRepository.Add(friend);
                }

                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            {
                var member = uow.MemberRepository.Get(_member.Id);
                _loadedFriends = uow.FriendRepository.GetFor(member);
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                foreach (var friend in _friends)
                {
                    uow.FriendRepository.Remove(uow.FriendRepository.Get(friend.Id));
                }

                foreach (var member in _members)
                {
                    uow.MemberRepository.Remove(uow.MemberRepository.Get(member.Id));
                }
                
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_member_is_null()
        {
            using (var uow = new UnitOfWork())
            {
                uow.FriendRepository.GetFor((Member)null);
            }
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_loadedFriends);
        }

        [TestMethod]
        public void returned_enumerable_has_actual_count()
        {
            Assert.AreEqual(_friends.Count(), _loadedFriends.Count());
        }

        [TestMethod]
        public void returned_enumerable_has_actual_friends()
        {
            foreach (var friend in _loadedFriends)
            {
                Assert.AreEqual(1, _friends.Where(f => f.Id == friend.Id).Count());
            }
        }
    }
}
