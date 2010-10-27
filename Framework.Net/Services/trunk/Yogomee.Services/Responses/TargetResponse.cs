using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace Yogomee.Services.Responses
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class TargetResponse
    {
        [DataMember(Name = "id")]
        public Int32 Id;

        [DataMember(Name = "memberId")]
        public Int32 MemberId;

        [DataMember(Name = "gomeeId")]
        public Int32 GomeeId;
    }
}
