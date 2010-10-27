using System;
using System.Runtime.Serialization;

namespace Yogomee.Services.Responses
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class MemberResponse
    {
        [DataMember(Name = "id")]
        public Int32 Id;

        [DataMember(Name = "email")]
        public String Email;
    }
}
