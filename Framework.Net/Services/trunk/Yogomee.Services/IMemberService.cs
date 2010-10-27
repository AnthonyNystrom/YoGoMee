using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Web;
using Genetibase.ServiceModel;
using Yogomee.Services.Responses;

namespace Yogomee.Services
{
    [ServiceContract]
    public interface IMemberService
    {
        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "add?e={email}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        MemberResponse AddMember(String email);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "get?m={memberId}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        MemberResponse GetMember(Int32 memberId);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "remove?m={memberId}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        void RemoveMember(Int32 memberId);
    }
}
