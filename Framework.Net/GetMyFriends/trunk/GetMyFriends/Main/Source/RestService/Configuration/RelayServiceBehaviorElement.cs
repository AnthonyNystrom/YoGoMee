using System;
using System.ServiceModel.Configuration;

namespace RestService.Configuration
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
