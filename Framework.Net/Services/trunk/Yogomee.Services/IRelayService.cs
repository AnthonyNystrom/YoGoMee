/* ------------------------------------------------
 * IRelayService.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System.IO;
using System.ServiceModel;
using System.ServiceModel.Web;

namespace Yogomee.Services
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
