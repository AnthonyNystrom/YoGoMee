using System.IO;
using System.ServiceModel;
using System.ServiceModel.Web;

namespace RestService
{
    [ServiceContract]
    public interface IRelayService
    {
        [OperationContract]
        [WebInvoke(
            BodyStyle = WebMessageBodyStyle.Bare,
            Method = "POST")]
        void UploadImage(Stream stream);
    }
}
