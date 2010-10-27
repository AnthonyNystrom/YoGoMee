/* ------------------------------------------------
 * IUnitOfWork.cs
 * Copyright © 2009 Alex Nesterov, Oleg Shnitko
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Diagnostics.CodeAnalysis;

namespace Genetibase.DomainModel
{
    public interface IUnitOfWork : IDisposable
    {
        [SuppressMessage("Microsoft.Design", "CA1004", Justification = "We do not consider compatibility with languages that do not support generics.")]
        IDataSource<T> GetDataSource<T>() where T : class;
        void PersistAll();
    }
}
