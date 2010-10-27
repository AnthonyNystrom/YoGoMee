/* ------------------------------------------------
 * FaultingWebHttpBehaviorElement.cs
 * Copyright © 2008 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel.Configuration;

namespace Genetibase.ServiceModel
{
    public class FaultingWebHttpBehaviorElement : BehaviorExtensionElement
    {
        public override Type BehaviorType
        {
            get { return typeof(FaultingWebHttpBehavior); }
        }

        protected override Object CreateBehavior()
        {
            return new FaultingWebHttpBehavior();
        }
    }
}
