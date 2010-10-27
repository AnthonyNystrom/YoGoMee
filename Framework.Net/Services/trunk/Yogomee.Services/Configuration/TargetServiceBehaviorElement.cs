﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel.Configuration;

namespace Yogomee.Services.Configuration
{
    public class TargetServiceBehaviorElement : BehaviorExtensionElement
    {
        public override Type BehaviorType
        {
            get { return typeof(TargetServiceBehavior); }
        }

        protected override Object CreateBehavior()
        {
            return new TargetServiceBehavior();
        }
    }
}
