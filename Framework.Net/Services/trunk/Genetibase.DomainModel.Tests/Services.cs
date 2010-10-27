/* ------------------------------------------------
 * Services.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using Genetibase.DomainModel;

namespace Genetibase.DomainModel.Tests
{
    public static class Services
    {
        public static BrokenRuleException<Object> SerializeDeserialize(this BrokenRuleException<Object> e)
        {
            BrokenRuleException<Object> result;
            var formatter = new BinaryFormatter();
            using (var ms = new MemoryStream())
            {
                formatter.Serialize(ms, e);
                ms.Flush();
                ms.Seek(0, SeekOrigin.Begin);
                result = formatter.Deserialize(ms) as BrokenRuleException<Object>;
            }
            return result;
        }

        public static Rule<Object> SerializeDeserialize(this Rule<Object> rule)
        {
            Rule<Object> result;
            var formatter = new BinaryFormatter();

            using (var ms = new MemoryStream())
            {
                formatter.Serialize(ms, rule);
                ms.Flush();
                ms.Seek(0, SeekOrigin.Begin);

                result = (Rule<Object>)formatter.Deserialize(ms);
            }

            return result;
        }
    }
}
