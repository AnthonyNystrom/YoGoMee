using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel.Dispatcher;
using System.ServiceModel;
using System.ServiceModel.Channels;

namespace Yogomee.Services.Configuration
{
    public class TargetServiceFactory : IInstanceProvider
    {
        public Object GetInstance(InstanceContext instanceContext, Message message)
        {
            return GetInstance(instanceContext);
        }

        public Object GetInstance(InstanceContext instanceContext)
        {
            return new TargetService();
        }

        public void ReleaseInstance(InstanceContext instanceContext, Object instance)
        {
        }
    }
}
