using System;
using System.ServiceModel;
using System.ServiceModel.Web;
using Genetibase.ServiceModel;

namespace RestService
{
    [ServiceContract]
    public interface IDefaultService
    {
        [OperationContract]
        [FaultContract(typeof(ArgumentFault))]
        [WebGet(
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "go")]
        void Go();
    }
}
