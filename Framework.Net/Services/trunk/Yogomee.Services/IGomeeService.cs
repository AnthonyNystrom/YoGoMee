/* ------------------------------------------------
 * IGomeeService.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel;
using System.ServiceModel.Web;
using Genetibase.ServiceModel;
using Yogomee.Services.GMaps;
using Yogomee.Services.Responses;

namespace Yogomee.Services
{
    [ServiceContract(Name="GomeeService", Namespace = "http://www.yogomee.com/")]
    public interface IGomeeService
    {
        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "gmaps?q={query}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        GResponse GMapsSearch(String query);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "add?m={memberId}&c={caption}&a={address}&d={description}&lat={latitude}&lng={longitude}&t={type}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        GomeeResponse AddGomee(
            Int32 memberId,
            String caption,
            String address,
            String description,
            Double latitude,
            Double longitude,
            Int32 type);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "save?g={gomeeId}&c={caption}&a={address}&d={description}&lat={latitude}&lng={longitude}&t={type}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        GomeeResponse SaveGomee(
            Int32 gomeeId,
            String caption,
            String address,
            String description,
            Double latitude,
            Double longitude,
            Int32 type);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "remove?m={memberId}&g={gomeeId}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        void RemoveGomee(Int32 memberId, Int32 gomeeId);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "mine?m={memberId}&f={firstIndex}&l={lastIndex}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        GomeesResponse GetMineGomees(Int32 memberId, Int32 firstIndex, Int32 lastIndex);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "theirs?m={memberId}&f={firstIndex}&l={lastIndex}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        GomeesResponse GetTheirsGomees(Int32 memberId, Int32 firstIndex, Int32 lastIndex);
    }
}
