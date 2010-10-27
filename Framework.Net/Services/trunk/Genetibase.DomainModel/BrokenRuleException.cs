/* ------------------------------------------------
 * BrokenRuleException.cs
 * Copyright © 2009 Alex Nesterov, Oleg Shnitko
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Security.Permissions;
using System.Text;
using System.Runtime.Serialization;

namespace Genetibase.DomainModel
{
    [Serializable]
    public class BrokenRuleException<T> : Exception
    {
        public BrokenRuleException()
            : this(null, default(T))
        {
        }

        public BrokenRuleException(String message, Exception innerException)
            : base(message, innerException)
        {
            BrokenRules = new List<Rule<T>>();
        }

        public BrokenRuleException(String message)
            : this(message, null)
        {
        }

        [SuppressMessage("Microsoft.Design", "CA1006", Justification = "We do not consider compatibility with languages that do not support generics.")]
        public BrokenRuleException(IEnumerable<Rule<T>> brokenRules, T entity)
            : this(GetMessage(brokenRules, entity))
        {
            Entity = entity;
            BrokenRules = brokenRules != null ? brokenRules : new List<Rule<T>>();
        }

        internal protected BrokenRuleException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
            BrokenRules = (IEnumerable<Rule<T>>)info.GetValue("BrokenRules", typeof(IEnumerable<Rule<T>>));
            Entity = (T)info.GetValue("Entity", typeof(T));
        }

        [SecurityPermission(SecurityAction.Demand, SerializationFormatter = true)]
        public override void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            if (info == null)
                throw new ArgumentNullException("info");

            info.AddValue("BrokenRules", BrokenRules, typeof(IEnumerable<Rule<T>>));
            info.AddValue("Entity", Entity, typeof(T));
            base.GetObjectData(info, context);
        }

        [SuppressMessage("Microsoft.Design", "CA1006", Justification = "We do not consider compatibility with languages that do not support generics.")]
        public IEnumerable<Rule<T>> BrokenRules
        {
            get;
            private set;
        }

        public T Entity
        {
            get;
            private set;
        }

        private static String GetMessage(IEnumerable<Rule<T>> brokenRules, T entity)
        {
            if (brokenRules == null || entity == null)
                return "";

            var msg = new StringBuilder();
            msg.Append(String.Format(
                CultureInfo.InvariantCulture,
                "There are broken rules on object {0}:",
                entity.ToString()));
            foreach (var rule in brokenRules)
                msg.Append(String.Format(CultureInfo.InvariantCulture, " {0};", rule.Message));
            return msg.ToString();
        }
    }
}
