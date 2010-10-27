/* ------------------------------------------------
 * Rule.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;
using System.Security.Permissions;

namespace Genetibase.DomainModel
{
    [Serializable]
    public sealed class Rule<T> : ISerializable
    {
        private Predicate<T> _predicate;

        public Rule(Predicate<T> predicate)
            : this(predicate, null)
        {
        }

        public Rule(Predicate<T> predicate, String message)
        {
            _predicate = predicate;
            Message = message;
        }

        internal Rule(SerializationInfo info, StreamingContext context)
        {
            if (info == null)
                throw new ArgumentNullException("info");

            _predicate = (Predicate<T>)info.GetValue("RulePredicate", typeof(Predicate<T>));
            Message = info.GetString("Message");
        }

        public Boolean Check(T source)
        {
            return _predicate(source);
        }

        public String Message
        {
            get;
            set;
        }

        [SecurityPermission(SecurityAction.LinkDemand, Flags = SecurityPermissionFlag.SerializationFormatter)]
        public void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            if (info == null)
                throw new ArgumentNullException("info");

            info.AddValue("RulePredicate", _predicate, typeof(Predicate<T>));
            info.AddValue("Message", Message);
        }
    }
}
