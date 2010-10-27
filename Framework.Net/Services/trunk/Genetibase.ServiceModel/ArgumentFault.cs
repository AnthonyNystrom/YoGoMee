/* ------------------------------------------------
 * ArgumentFault.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Genetibase.ServiceModel
{
    [DataContract]
    public class ArgumentFault : FaultBase
    {
        [DataMember]
        public String Argument { get; set; }
        [DataMember]
        public String Value { get; set; }
    }
}
