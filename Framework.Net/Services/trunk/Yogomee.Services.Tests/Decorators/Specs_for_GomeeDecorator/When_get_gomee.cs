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
using System.ServiceModel;
using Genetibase.ServiceModel;

namespace Specs_for_GomeeDecorator
{
    [TestClass]
    public sealed class When_get_gomee
    {
        private static IGomeeDecorator _gomeeDecorator;

        private static IUnitOfWork _unitOfWork;
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;

        private static Member _member;
        private static Gomee _gomee;
        private static Gomee _loadedGomee;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _gomeeDecorator = new GomeeDecorator(_gomeeFactory, _unitOfWork.GomeeRepository);

            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            _gomee = _gomeeFactory.CreateGomee(_member);

            using (var uow = new UnitOfWork())
            {
                uow.MemberRepository.Add(_member);
                uow.GomeeRepository.Add(_gomee);
                uow.PersistAll();
            }

            _loadedGomee = _gomeeDecorator.Get(_gomee.Id);
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                uow.GomeeRepository.Remove(uow.GomeeRepository.Get(_gomee.Id));
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();
            }

            _unitOfWork.Close();
        }

        [TestMethod]
        [ExpectedException(typeof(FaultException<ArgumentFault>))]
        public void throws_ArgumentFaultException_when_gomee_not_exist()
        {
            _gomeeDecorator.Get(0);
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_loadedGomee);
        }

        [TestMethod]
        public void has_actual_Id()
        {
            Assert.AreEqual(_gomee.Id, _loadedGomee.Id);
        }

        [TestMethod]
        public void has_actual_Member()
        {
            Assert.AreEqual(_gomee.Member.Id, _loadedGomee.Member.Id);
        }

        [TestMethod]
        public void has_actual_Caption()
        {
            Assert.AreEqual(_gomee.Caption, _loadedGomee.Caption);
        }

        [TestMethod]
        public void has_actual_Address()
        {
            Assert.AreEqual(_gomee.Address, _loadedGomee.Address);
        }

        [TestMethod]
        public void has_actual_Description()
        {
            Assert.AreEqual(_gomee.Description, _loadedGomee.Description);
        }

        [TestMethod]
        public void has_actual_Latitude()
        {
            Assert.AreEqual(_gomee.Latitude, _loadedGomee.Latitude);
        }

        [TestMethod]
        public void has_actual_Longitude()
        {
            Assert.AreEqual(_gomee.Longitude, _loadedGomee.Longitude);
        }

        [TestMethod]
        public void has_actual_GomeeType()
        {
            Assert.AreEqual(_gomee.GomeeType, _loadedGomee.GomeeType);
        }

        [TestMethod]
        public void has_actual_Version()
        {
            Assert.AreEqual(_gomee.Version, _loadedGomee.Version);
        }

        [TestMethod]
        public void has_actual_Created()
        {
            Assert.AreEqual(_gomee.Created.Year, _loadedGomee.Created.Year);
            Assert.AreEqual(_gomee.Created.Month, _loadedGomee.Created.Month);
            Assert.AreEqual(_gomee.Created.Day, _loadedGomee.Created.Day);
            Assert.AreEqual(_gomee.Created.Hour, _loadedGomee.Created.Hour);
            Assert.AreEqual(_gomee.Created.Minute, _loadedGomee.Created.Minute);
            Assert.AreEqual(_gomee.Created.Second, _loadedGomee.Created.Second);
        }
    }
}
