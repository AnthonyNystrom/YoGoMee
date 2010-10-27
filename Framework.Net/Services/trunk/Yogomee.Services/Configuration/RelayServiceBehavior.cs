/* ------------------------------------------------
 * RelayServiceBehavior.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;

namespace Yogomee.Services.Configuration
{
    public sealed class RelayServiceBehavior : IEndpointBehavior
    {
        public void ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
            endpointDispatcher.DispatchRuntime.InstanceProvider = new RelayServiceFactory();
        }

        public void AddBindingParameters(ServiceEndpoint endpoint, System.ServiceModel.Channels.BindingParameterCollection bindingParameters)
        {
        }
        public void ApplyClientBehavior(ServiceEndpoint endpoint, System.ServiceModel.Dispatcher.ClientRuntime clientRuntime)
        {
        }
        public void Validate(ServiceEndpoint endpoint)
        {
        }
    }
}
