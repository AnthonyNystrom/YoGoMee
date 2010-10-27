using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.Storage.Repositories;

namespace Specs_for_FriendRepository
{
    [TestClass]
    public sealed class Ctor_session
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_session_is_null()
        {
            new FriendRepository(null);
        }
    }
}
