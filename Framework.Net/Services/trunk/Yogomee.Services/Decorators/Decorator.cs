using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Yogomee.Services.DomainModel.Repositories;
using Genetibase.ServiceModel;
using System.Globalization;
using System.Diagnostics;

namespace Yogomee.Services.Decorators
{
    public abstract class Decorator<T> : IDecorator<T> where T : class
    {
        private IRepository<T> _repository;

        public Decorator(IRepository<T> repository)
        {
            if (repository == null)
                throw new ArgumentNullException("repository");

            _repository = repository;
        }

        protected IRepository<T> Repository
        {
            get
            {
                Debug.Assert(_repository != null, "_repository != null");
                return _repository;
            }
        }

        public virtual void Add(T entity)
        {
            if (entity == null)
                throw new ArgumentNullException("entity");

            Repository.Add(entity);
        }

        public virtual T Get(Int32 entityId)
        {
            try
            {
                return Repository.Get(entityId);
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault() 
                    {
                        Argument = "entityId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            "{0} with specified id not exists.",
                            typeof(T).Name),
                        Value = entityId.ToString(CultureInfo.InvariantCulture)
                    });
            }
        }

        public virtual void Remove(T entity)
        {
            if (entity == null)
                throw new ArgumentNullException("entity");

            Repository.Remove(entity);
        }

        public virtual Int32 Count()
        {
            return Repository.Count();
        }
    }
}
