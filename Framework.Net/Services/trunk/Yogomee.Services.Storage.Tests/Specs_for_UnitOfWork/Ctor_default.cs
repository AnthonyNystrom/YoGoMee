using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.Storage;

namespace Specs_for_UnitOfWork
{
    [TestClass]
    public class Ctor_default
    {
        private static UnitOfWork _unitOfWork;

        [ClassInitialize]
        public static void SetUp(TestContext context)
        {
            _unitOfWork = new UnitOfWork();
        }

        [ClassCleanup]
        public static void CleanUp()
        {
            _unitOfWork.Dispose();
        }

        [TestMethod]
        public void MemberRepository_is_not_null()
        {
            Assert.IsNotNull(_unitOfWork.MemberRepository);
        }

        [TestMethod]
        public void FriendRepository_is_not_null()
        {
            Assert.IsNotNull(_unitOfWork.FriendRepository);
        }

        [TestMethod]
        public void GomeeRepository_is_not_null()
        {
            Assert.IsNotNull(_unitOfWork.GomeeRepository);
        }

        [TestMethod]
        public void TargetRepository_is_not_null()
        {
            Assert.IsNotNull(_unitOfWork.TargetRepository);
        }
    }
}
