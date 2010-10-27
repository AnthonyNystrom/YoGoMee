using System;
using Genetibase.ServiceModel;

namespace RestService
{
    public class DefaultService : IDefaultService
    {
        private IServiceContext _serviceContext;

        public DefaultService()
        {
            _serviceContext = new ServiceContext();
        }

        public void Go()
        {
        }
    }
}
