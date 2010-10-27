using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace Yogomee.Services.Responses
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GomeeResponse
    {
        [DataMember(Name = "id")]
        public Int32 Id;

        [DataMember(Name = "memberId")]
        public Int32 MemberId;

        [DataMember(Name = "caption")]
        public String Caption;

        [DataMember(Name = "address")]
        public String Address;

        [DataMember(Name = "description")]
        public String Description;

        [DataMember(Name = "latitude")]
        public Double Latitude;

        [DataMember(Name = "longitude")]
        public Double Longitude;

        [DataMember(Name = "type")]
        public Int32 Type;
    }
}
