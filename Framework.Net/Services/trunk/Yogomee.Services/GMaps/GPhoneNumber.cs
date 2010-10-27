/* ------------------------------------------------
 * GPhoneNumber.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Yogomee.Services.GMaps
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GPhoneNumber
    {
        [DataMember(Name = "type")]
        public String Type;
        [DataMember(Name = "number")]
        public String Number;
    }
}
