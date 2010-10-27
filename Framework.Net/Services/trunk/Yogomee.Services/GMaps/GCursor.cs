/* ------------------------------------------------
 * GCursor.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Yogomee.Services.GMaps
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GCursor
    {
        [DataMember(Name = "pages")]
        public GPage[] Pages;
        [DataMember(Name = "estimatedResultCount")]
        public Int32 EstimatedResultCount;
        [DataMember(Name = "currentPageIndex")]
        public Int32 CurrentPageIndex;
        [DataMember(Name = "moreResultsUrl")]
        public String MoreResultsUrl;
    }
}
