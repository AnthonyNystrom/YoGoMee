/* ------------------------------------------------
 * GomeeServiceFactory.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Dispatcher;

namespace Yogomee.Services.Configuration
{
    public class GomeeServiceFactory : IInstanceProvider
    {
        public Object GetInstance(InstanceContext instanceContext, Message message)
        {
            return GetInstance(instanceContext);
        }

        public Object GetInstance(InstanceContext instanceContext)
        {
            return new GomeeService();
        }

        public void ReleaseInstance(InstanceContext instanceContext, Object instance)
        {
        }
    }
}
