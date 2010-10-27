/* ------------------------------------------------
 * GResponse.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Yogomee.Services.GMaps
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GResponse
    {
        [DataMember(Name = "responseData")]
        public GData Data;
        [DataMember(Name = "responseDetails")]
        public String Details;
        [DataMember(Name = "responseStatus")]
        public Int32 Status;
    }
}
