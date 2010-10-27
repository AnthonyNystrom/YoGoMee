using System;
using System.ServiceModel.Configuration;

namespace RestService.Configuration
{
    public class DefaultServiceBehaviorElement : BehaviorExtensionElement
    {
        public override Type BehaviorType
        {
            get { return typeof(DefaultServiceBehavior); }
        }

        protected override Object CreateBehavior()
        {
            return new DefaultServiceBehavior();
        }
    }
}
