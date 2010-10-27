/* ------------------------------------------------
 * GPage.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Yogomee.Services.GMaps
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GPage
    {
        [DataMember(Name = "start")]
        public String Start;
        [DataMember(Name = "label")]
        public String Label;
    }
}
