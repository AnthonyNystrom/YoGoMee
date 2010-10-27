using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel;
using Yogomee.Services.Decorators;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;
using Yogomee.Services.DomainModel.Factories;

namespace Specs_for_FriendDecorator
{
    [TestClass]
    public sealed class When_remove_friend
    {
        private static IUnitOfWork _unitOfWork;
        private static IMemberDecorator _memberDecorator;
        private static IFriendDecorator _friendDecorator;

        private static Member _member1;
        private static Member _member2;

        private static Friend _friend;
        private static Friend _loadedFriend;
        private static Int32 _oldCount;
        private static Int32 _newCount;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _memberDecorator = new MemberDecorator(new MemberFactory(), _unitOfWork.MemberRepository);
            _friendDecorator = new FriendDecorator(new FriendFactory(), _unitOfWork.FriendRepository);

            _member1 = _memberDecorator.CreateMember(Guid.NewGuid().ToString());
            _member2 = _memberDecorator.CreateMember(Guid.NewGuid().ToString());

            _friend = _friendDecorator.CreateFriend(_member1, _member2);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member1);
                uow.MemberRepository.Add(_member2);

                uow.FriendRepository.Add(_friend);

                uow.PersistAll();
                _oldCount = uow.FriendRepository.Count();
            }

            _friendDecorator.Remove(_unitOfWork.FriendRepository.Get(_friend.Id));
            _unitOfWork.PersistAll();

            _newCount = _unitOfWork.FriendRepository.Count();

            try
            {
                _loadedFriend = _unitOfWork.FriendRepository.Get(_friend.Id);
            }
            catch (ArgumentException)
            {
                _loadedFriend = null;
            }

        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.MemberRepository.Remove(_unitOfWork.MemberRepository.Get(_member1.Id));
            _unitOfWork.MemberRepository.Remove(_unitOfWork.MemberRepository.Get(_member2.Id));
            _unitOfWork.PersistAll();
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_friend_is_null()
        {
            _friendDecorator.Remove(null);
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
