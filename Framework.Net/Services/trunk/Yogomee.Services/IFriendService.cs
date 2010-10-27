/* ------------------------------------------------
 * File: IFriendService.cs
 * 
 * Created: 2/17/2009
 * Modified: 2/17/2009
 * 
 * Copyright © Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel;
using System.ServiceModel.Web;
using Genetibase.ServiceModel;
using Yogomee.Services.Integration;
using Yogomee.Services.Responses;

namespace Yogomee.Services
{
    [ServiceContract(Name="FriendService", Namespace="http://www.yogomee.com/")]
    public interface IFriendService
    {
        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "contacts?u={username}&p={password}&s={contactService}")]
        [FaultContract(typeof(ArgumentFault))]
        [OperationContract]
        Contact[] GetContacts(String username, String password, String contactService);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "add?m={memberId}&fm={friendMemberId}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        FriendResponse AddFriend(
            Int32 memberId,
            Int32 friendMemberId);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "remove?m={memberId}&fm={friendMemberId}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        void RemoveFriend(
            Int32 memberId,
            Int32 friendMemberId);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "friends?m={memberId}&f={firstIndex}&l={lastIndex}"),
        FaultContract(
            typeof(ArgumentFault)),
        OperationContract()]
        FriendsResponse GetFriends(
            Int32 memberId,
            Int32 firstIndex,
            Int32 lastIndex);
    }
}
