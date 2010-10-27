/* ------------------------------------------------
 * FaultingWebHttpBehavior.cs
 * Copyright © 2008 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Diagnostics;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;

namespace Genetibase.ServiceModel
{
    public class FaultingWebHttpBehavior : WebHttpBehavior
    {
        private class ErrorHandler : IErrorHandler
        {
            public Boolean HandleError(Exception error)
            {
                return true;
            }

            public void ProvideFault(Exception error, MessageVersion version, ref Message fault)
            {
                Debug.Assert(error != null, "error != null");
                Debug.WriteLine(String.Format("ProvideFault - error type is {0}.", error.GetType()));

                fault = FaultService.CreateJsonFault(
                    error,
                    version,
                    error is FaultException ? HttpStatusCode.BadRequest : HttpStatusCode.InternalServerError);
            }
        }

        protected override void AddServerErrorHandlers(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
            endpointDispatcher.ChannelDispatcher.ErrorHandlers.Clear();
            endpointDispatcher.ChannelDispatcher.ErrorHandlers.Add(new ErrorHandler());
        }
    }
}
