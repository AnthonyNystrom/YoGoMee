using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;
using Yogomee.Services.Decorators;
using Yogomee.Services.DomainModel;
using Genetibase.ServiceModel;
using System.ServiceModel;

namespace Specs_for_MemberDecorator
{
    [TestClass]
    public sealed class When_add_member
    {
        private static IUnitOfWork _unitOfWork;
        private static MemberDecorator _decorator;

        private static String _email;
        private static Member _member;
        private static Member _sameMember;
        private static Member _loadedMember;
        private static Int32 _oldCount;
        private static Int32 _newCount;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            var memberFactory = new MemberFactory();

            _email = Guid.NewGuid().ToString();

            _decorator = new MemberDecorator(memberFactory, _unitOfWork.MemberRepository);

            _oldCount = _unitOfWork.MemberRepository.Count();
            _member = memberFactory.CreateMember(_email);
            _sameMember = memberFactory.CreateMember(_email);

            _decorator.Add(_member);
            _unitOfWork.PersistAll();

            using (var uow = new UnitOfWork())
            {
                _newCount = uow.MemberRepository.Count();
                try
                {
                    _loadedMember = uow.MemberRepository.Get(_member.Id);
                }
                catch (Exception)
                {
                    _loadedMember = null;
                }
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.MemberRepository.Remove(_member);
            _unitOfWork.PersistAll();
            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_member_is_null()
        {
            _decorator.Add(null);
        }

        [TestMethod]
        [ExpectedException(typeof(FaultException<ArgumentFault>))]
        public void throws_ArgumentFaultException_if_member_with_specified_email_exist()
        {
            _decorator.Add(_sameMember);
        }

        [TestMethod]
        public void member_count_increase()
        {
            Assert.AreEqual(_oldCount + 1, _newCount);
        }

        [TestMethod]
        public void added_member_exist()
        {
            Assert.IsNotNull(_loadedMember);
        }
    }
}
