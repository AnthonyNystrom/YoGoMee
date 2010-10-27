/* ------------------------------------------------
 * Repository.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace Genetibase.DomainModel
{
    public abstract class Repository<T> : IRepository where T : class
    {
        private IDataSource<T> _dataSource;

        protected Repository(IDataSource<T> dataSource)
        {
            if (dataSource == null)
                throw new ArgumentNullException("dataSource");

            _dataSource = dataSource;
        }

        protected IDataSource<T> DataSource
        {
            get
            {
                Debug.Assert(_dataSource != null, "_dataSource != null");
                return _dataSource;
            }
        }

        protected void Add(T entity)
        {
            DataSource.Add(entity);
        }

        protected Int32 Count
        {
            get
            {
                return DataSource.Count();
            }
        }

        protected IEnumerable<T> Entities
        {
            get
            {
                return DataSource.AsEnumerable();
            }
        }

        public virtual void PersistAll()
        {
            _dataSource.PersistAll();
        }

        protected Boolean Remove(T entity)
        {
            return DataSource.Remove(entity);
        }
    }
}
