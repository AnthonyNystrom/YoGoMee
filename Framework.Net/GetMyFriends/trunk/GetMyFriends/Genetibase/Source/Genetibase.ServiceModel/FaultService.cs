/* ------------------------------------------------
 * FaultService.cs
 * Copyright © 2008 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Net;
using System.Runtime.Serialization.Json;
using System.ServiceModel;
using System.ServiceModel.Channels;

namespace Genetibase.ServiceModel
{
    public static class FaultService
    {
        public static Object GetFaultDetail(Exception error)
        {
            if (error == null)
                throw new ArgumentNullException("error");

            var faultException = error as FaultException;

            if (faultException != null && faultException.GetType().IsGenericType)
            {
                var detailProperty = faultException.GetType().GetProperty("Detail");
                Debug.Assert(detailProperty != null, "detailProperty != null");
                var getMethod = detailProperty.GetGetMethod();
                Debug.Assert(getMethod != null, "getMethod != null");
                return getMethod.Invoke(error, null);
            }

            return error.Message;
        }

        [SuppressMessage("Microsoft.Naming", "CA1704", Justification = "Actually the name is ok. Refer to DataContractJsonSerializer for instance.")]
        public static Message CreateJsonFault(Exception error, MessageVersion version, HttpStatusCode statusCode)
        {
            if (error == null)
                throw new ArgumentNullException("error");
            if (version == null)
                throw new ArgumentNullException("version");

            var details = GetFaultDetail(error);
            var fault = Message.CreateMessage(
                version, "", details,
                new DataContractJsonSerializer(details.GetType()));
            fault.Properties.Add(
                WebBodyFormatMessageProperty.Name,
                new WebBodyFormatMessageProperty(WebContentFormat.Json));
            fault.Properties.Add(
                HttpResponseMessageProperty.Name,
                new HttpResponseMessageProperty()
                {
                    StatusCode = statusCode,
                    StatusDescription = error.GetType().ToString()
                });
            return fault;
        }
    }
}
