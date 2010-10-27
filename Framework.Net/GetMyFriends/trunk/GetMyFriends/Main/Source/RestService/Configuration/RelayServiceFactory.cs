using System;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Dispatcher;

namespace RestService.Configuration
{
    public class RelayServiceFactory : IInstanceProvider
    {
        public Object GetInstance(InstanceContext instanceContext, Message message)
        {
            return GetInstance(instanceContext);
        }

        public Object GetInstance(System.ServiceModel.InstanceContext instanceContext)
        {
            return new RelayService();
        }

        public void ReleaseInstance(System.ServiceModel.InstanceContext instanceContext, Object instance)
        {
        }
    }
}
