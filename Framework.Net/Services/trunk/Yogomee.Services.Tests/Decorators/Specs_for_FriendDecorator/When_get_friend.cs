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
using System.ServiceModel;
using Genetibase.ServiceModel;

namespace Specs_for_FriendDecorator
{
    [TestClass]
    public sealed class When_get_friend
    {
        private static IUnitOfWork _unitOfWork;
        private static IMemberDecorator _memberDecorator;
        private static IFriendDecorator _friendDecoartor;

        private static Member _member1;
        private static Member _member2;

        private static Friend _friend;
        private static Friend _loadedFriend;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _memberDecorator = new MemberDecorator(new MemberFactory(), _unitOfWork.MemberRepository);
            _friendDecoartor = new FriendDecorator(new FriendFactory(), _unitOfWork.FriendRepository);

            _member1 = _memberDecorator.CreateMember(Guid.NewGuid().ToString());
            _member2 = _memberDecorator.CreateMember(Guid.NewGuid().ToString());

            _friend = _friendDecoartor.CreateFriend(_member1, _member2);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member1);
                uow.MemberRepository.Add(_member2);

                uow.FriendRepository.Add(_friend);
                uow.PersistAll();
            }

            _loadedFriend = _friendDecoartor.Get(_friend.Id);
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.FriendRepository.Remove(_unitOfWork.FriendRepository.Get(_friend.Id));

            _unitOfWork.MemberRepository.Remove(_unitOfWork.MemberRepository.Get(_member1.Id));
            _unitOfWork.MemberRepository.Remove(_unitOfWork.MemberRepository.Get(_member2.Id));
            _unitOfWork.PersistAll();
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(FaultException<ArgumentFault>))]
        public void throws_ArgumentFaultException_when_friend_not_exist()
        {
            _friendDecoartor.Get(0);
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
