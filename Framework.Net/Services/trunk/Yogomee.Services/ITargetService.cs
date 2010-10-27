using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel;
using System.ServiceModel.Web;
using Genetibase.ServiceModel;
using Yogomee.Services.Responses;

namespace Yogomee.Services
{
    [ServiceContract(Name = "GomeeService", Namespace = "http://www.yogomee.com/")]
    public interface ITargetService
    {
        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "add?m={memberId}&g={gomeeId}&t={targetId}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        TargetResponse AddTarget(Int32 memberId, Int32 gomeeId, Int32 targetId);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "remove?m={memberId}&g={gomeeId}&t={targetId}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        void RemoveTarget(Int32 memberId, Int32 gomeeId, Int32 targetId);
    }
}
