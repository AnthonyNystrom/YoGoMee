/* ------------------------------------------------
 * File: FriendServiceFactory.cs
 * 
 * Created: 2/17/2009
 * Modified: 2/17/2009
 * 
 * Copyright © Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Dispatcher;

namespace Yogomee.Services.Configuration
{
    public class FriendServiceFactory : IInstanceProvider
    {
        public Object GetInstance(InstanceContext instanceContext, Message message)
        {
            return GetInstance(instanceContext);
        }

        public Object GetInstance(InstanceContext instanceContext)
        {
            return new FriendService();
        }

        public void ReleaseInstance(InstanceContext instanceContext, Object instance)
        {
        }
    }
}
