/* ------------------------------------------------
 * When_serializing.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;
using Genetibase.DomainModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;

namespace Specs_for_Rule
{
    [TestClass]
    public sealed class When_serializing
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void CtorChecksIfInfoIsNull()
        {
            new Rule<Object>((SerializationInfo)null, new StreamingContext());
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void GetObjectDataChecksIfInfoIsNull()
        {
            var rule = new Rule<Object>(o => o != null);
            rule.GetObjectData(null, new StreamingContext());
        }

        [TestMethod]
        public void CanSerializeWithPredicate()
        {
            TestRuleSerialization(null);
        }

        [TestMethod]
        public void CanSerializeWithPredicateAndMessage()
        {
            TestRuleSerialization("o != null");
        }

        private void TestRuleSerialization(String message)
        {
            var rule = new Rule<Object>(o => o != null, message);
            var formatter = new BinaryFormatter();

            using (var ms = new MemoryStream())
            {
                formatter.Serialize(ms, rule);
                ms.Flush();
                ms.Seek(0, SeekOrigin.Begin);

                var ruleClone = (Rule<Object>)formatter.Deserialize(ms);

                Assert.AreEqual(rule.Message, ruleClone.Message);
                Assert.AreEqual(rule.Check(new Object()), ruleClone.Check(new Object()));
                Assert.AreEqual(rule.Check(null), ruleClone.Check(null));
            }
        }
    }
}
