/* ------------------------------------------------
 * IDataSource.cs
 * Copyright © 2009 Alex Nesterov, Oleg Shnitko
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace Genetibase.DomainModel
{
    public interface IDataSource
    {
        void ValidateChanges();
        void PersistAll();
    }

    [SuppressMessage("Microsoft.Naming", "CA1710", Justification = "Name of the interface matches design considerations.")]
    public interface IDataSource<T> : IQueryable<T>, IEnumerable<T>, IDataSource
    {
        void Add(T entity);
        Boolean Remove(T entity);
    }
}
