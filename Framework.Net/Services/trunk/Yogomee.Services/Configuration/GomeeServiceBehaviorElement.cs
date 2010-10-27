/* ------------------------------------------------
 * GomeeServiceBehaviorElement.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel.Configuration;

namespace Yogomee.Services.Configuration
{
    public class GomeeServiceBehaviorElement : BehaviorExtensionElement
    {
        public override Type BehaviorType
        {
            get { return typeof(GomeeServiceBehavior); }
        }

        protected override Object CreateBehavior()
        {
            return new GomeeServiceBehavior();
        }
    }
}
