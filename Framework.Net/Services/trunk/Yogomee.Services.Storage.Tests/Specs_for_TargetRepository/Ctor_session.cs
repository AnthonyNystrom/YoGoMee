using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Yogomee.Services.Storage.Repositories;

namespace Specs_for_TargetRepository
{
    [TestClass]
    public class Ctor_session
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void throws_ArgumentNullException_if_session_is_null()
        {
            new TargetRepository(null);
        }
    }
}
