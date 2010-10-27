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
    public sealed class When_add_friend
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

            _oldCount = _friendDecorator.Count();
            _memberDecorator.Add(_member1);
            _memberDecorator.Add(_member2);
            _friendDecorator.Add(_friend);
            _unitOfWork.PersistAll();

            using (var uow = new UnitOfWork())
            {
                _newCount = uow.FriendRepository.Count();
                _loadedFriend = uow.FriendRepository.Get(_friend.Id);
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.FriendRepository.Remove(_friend);
            _unitOfWork.MemberRepository.Remove(_member1);
            _unitOfWork.MemberRepository.Remove(_member2);
            _unitOfWork.PersistAll();
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_friend_is_null()
        {
            _friendDecorator.Add(null);
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
