using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace Yogomee.Services.Responses
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class FriendResponse
    {
        [DataMember(Name = "id")]
        public Int32 Id;

        [DataMember(Name = "member1Id")]
        public Int32 Member1Id;

        [DataMember(Name = "member2Id")]
        public Int32 Member2Id;
    }
}
