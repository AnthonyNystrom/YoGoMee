/* ------------------------------------------------
 * When_generating_new_WebId.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Text.RegularExpressions;
using Genetibase.DomainModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Specs_for_WebIdGenerator
{
    [TestClass]
    public sealed class When_generating_new_WebId
    {
        private IWebIdGenerator _generator = new WebIdGenerator();

        [TestMethod]
        public void pattern_matches()
        {
            Assert.IsTrue(Regex.IsMatch(_generator.NewWebId(), "^[a-zA-Z0-9]{8}$"));
        }
    }
}
