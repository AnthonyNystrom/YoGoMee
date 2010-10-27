using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.Storage.Repositories;

namespace Specs_for_MemberRepository
{
    [TestClass]
    public class Ctor_session
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void checks_if_session_is_null()
        {
            new MemberRepository(null);
        }
    }
}
