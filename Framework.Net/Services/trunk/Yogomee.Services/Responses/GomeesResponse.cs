using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace Yogomee.Services.Responses
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GomeesResponse
    {
        [DataMember(Name = "allCount")]
        public Int32 AllCount;

        [DataMember(Name = "responseCount")]
        public Int32 ResponseCount;

        [DataMember(Name = "firstIndex")]
        public Int32 FirstIndex;

        [DataMember(Name = "gomees")]
        public GomeeResponse[] Gomees;
    }
}
