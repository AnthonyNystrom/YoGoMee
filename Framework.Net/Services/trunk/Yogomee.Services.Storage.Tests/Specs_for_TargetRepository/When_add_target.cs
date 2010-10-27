﻿using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.Storage;

namespace Specs_for_TargetRepository
{
    [TestClass]
    public class When_add_target
    {
        private static IMemberFactory _memberFactory;
        private static IGomeeFactory _gomeeFactory;
        private static ITargetFactory _targetFactory;

        private static Member _member;
        private static Gomee _gomee;
        private static Target _target;
        private static Target _loadedTarget;

        private static Int32 _oldCount;
        private static Int32 _newCount;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _memberFactory = new MemberFactory();
            _gomeeFactory = new GomeeFactory();
            _targetFactory = new TargetFactory();

            _member = _memberFactory.CreateMember(Guid.NewGuid().ToString());
            _gomee = _gomeeFactory.CreateGomee(_member);
            _target = _targetFactory.CreateGomeeTarget(_member, _gomee);

            using (var uow = new UnitOfWork())
            {
                _oldCount = uow.TargetRepository.Count();
                uow.MemberRepository.Add(_member);
                uow.GomeeRepository.Add(_gomee);
                uow.TargetRepository.Add(_target);
                uow.PersistAll();
            }

            using (var uow = new UnitOfWork())
            {
                _newCount = uow.TargetRepository.Count();

                try
                {
                    _loadedTarget = uow.TargetRepository.Get(_target.Id);
                }
                catch (ArgumentException)
                {
                    _loadedTarget = null;
                }
            }
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            using (var uow = new UnitOfWork())
            {
                uow.TargetRepository.Remove(uow.TargetRepository.Get(_target.Id));
                uow.GomeeRepository.Remove(uow.GomeeRepository.Get(_gomee.Id));
                uow.MemberRepository.Remove(uow.MemberRepository.Get(_member.Id));
                uow.PersistAll();
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_target_is_null()
        {
            using (var uof = new UnitOfWork())
            {
                uof.TargetRepository.Add(null);
            }
        }

        [TestMethod]
        public void gomeeTargets_count_increase()
        {
            Assert.AreEqual(_oldCount + 1, _newCount);
        }

        [TestMethod]
        public void added_target_exist()
        {
            Assert.IsNotNull(_loadedTarget);
        }
    }
}
