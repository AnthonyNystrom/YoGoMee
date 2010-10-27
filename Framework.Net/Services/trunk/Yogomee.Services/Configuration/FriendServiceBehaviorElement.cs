/* ------------------------------------------------
 * File: FriendServiceBehaviorElement.cs
 * 
 * Created: 2/17/2009
 * Modified: 2/17/2009
 * 
 * Copyright © Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel.Configuration;

namespace Yogomee.Services.Configuration
{
    public class FriendServiceBehaviorElement : BehaviorExtensionElement
    {
        public override Type BehaviorType
        {
            get { return typeof(FriendServiceBehavior); }
        }

        protected override object CreateBehavior()
        {
            return new FriendServiceBehavior();
        }
    }
}
