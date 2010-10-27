/* ------------------------------------------------
 * FaultBase.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Genetibase.ServiceModel
{
    [DataContract]
    public abstract class FaultBase
    {
        [DataMember]
        public String Message { get; set; }
    }
}
