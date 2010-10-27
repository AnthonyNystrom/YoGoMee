using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.Storage.Repositories;

namespace Specs_for_GomeeRepository
{
    [TestClass]
    public sealed class Ctor_session
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_session_is_null()
        {
            new GomeeRepository(null);
        }
    }
}
