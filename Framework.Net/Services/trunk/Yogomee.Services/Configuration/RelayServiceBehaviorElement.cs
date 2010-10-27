/* ------------------------------------------------
 * RelayServiceBehaviorElement.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel.Configuration;

namespace Yogomee.Services.Configuration
{
    public class RelayServiceBehaviorElement : BehaviorExtensionElement
    {
        protected override Object CreateBehavior()
        {
            return new RelayServiceBehavior();
        }

        public override Type BehaviorType
        {
            get { return typeof(RelayServiceBehavior); }
        }
    }
}
