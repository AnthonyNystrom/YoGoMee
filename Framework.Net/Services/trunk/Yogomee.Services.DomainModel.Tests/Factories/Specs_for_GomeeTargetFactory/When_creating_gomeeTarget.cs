using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Factories;

namespace Specs_for_GomeeTargetFactory
{
    [TestClass]
    public class When_creating_gomeeTarget
    {
        private IMemberFactory _memberFactory;
        private IGomeeFactory _gomeeFactory;

        private TargetFactory _gomeeTargetFactory;

        private Member _member;
        private Gomee _gomee;
        private Target _gomeeTarget;

        public When_creating_gomeeTarget()
        {
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _gomeeTargetFactory = new TargetFactory();

            _member = _memberFactory.CreateMember("test@test.com");
            _gomee = _gomeeFactory.CreateGomee(_member);
            _gomeeTarget = _gomeeTargetFactory.CreateGomeeTarget(_member, _gomee);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_member_is_null()
        {
            _gomeeTargetFactory.CreateGomeeTarget(null, _gomee);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_gomee_is_null()
        {
            _gomeeTargetFactory.CreateGomeeTarget(_member, null);
        }

        [TestMethod]
        public void returns_not_null()
        {
            Assert.IsNotNull(_gomeeTarget);
        }

        [TestMethod]
        public void set_member()
        {
            Assert.AreEqual(_member, _gomeeTarget.Member);
        }

        [TestMethod]
        public void set_gomee()
        {
            Assert.AreEqual(_gomee, _gomeeTarget.Gomee);
        }

        [TestMethod]
        public void Created_is_not_null()
        {
            Assert.IsNotNull(_gomeeTarget.Created);
        }
    }
}
