using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Repositories;
using NHibernate;
using System.Diagnostics;
using System.Globalization;
using Yogomee.Services.Storage.Properties;
using NHibernate.Criterion;

namespace Yogomee.Services.Storage.Repositories
{
    public class Repository<T> : IRepository<T> where T : class
    {
        private ISession _session;

        public Repository(ISession session)
        {
            if (session == null)
                throw new ArgumentNullException("session");
            _session = session;
        }

        protected ISession Session
        {
            get
            {
                Debug.Assert(_session != null, "_session != null");
                return _session;
            }
        }

        public virtual void Add(T entity)
        {
            if (entity == null)
                throw new ArgumentNullException("entity");

            Session.Save(entity);
        }

        public virtual T Get(Int32 entityId)
        {
            var entiry = _session.Get<T>(entityId);

            if (entiry == null)
                throw new ArgumentException(
                    String.Format(
                        CultureInfo.InvariantCulture,
                        Resources.EntityNotExists_String,
                        typeof(T).Name),
                    entityId.ToString(CultureInfo.InvariantCulture));

            return entiry;
        }

        public virtual void Remove(T entity)
        {
            if (entity == null)
                throw new ArgumentNullException("entity");

            Session.Delete(entity);
        }

        public virtual Int32 Count()
        {
            return Session.CreateCriteria(typeof(T)).
                SetProjection(Projections.RowCount()).
                UniqueResult<Int32>();
        }
    }
}
