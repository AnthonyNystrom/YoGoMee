/* ------------------------------------------------
 * GData.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Yogomee.Services.GMaps
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GData
    {
        [DataMember(Name = "results")]
        public GResult[] Results;
        [DataMember(Name = "cursor")]
        public GCursor Cursor;
        [DataMember(Name = "viewport")]
        public GViewPort ViewPort;
    }
}
