using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Yogomee.Services.DomainModel.Repositories
{
    public interface IRepository<T> where T : class 
    {
        void Add(T entity);
        T Get(Int32 entityId);
        void Remove(T entity);
        Int32 Count();
    }
}
