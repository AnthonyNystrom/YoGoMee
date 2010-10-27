using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Yogomee.Services.Decorators
{
    public interface IDecorator<T> where T : class
    {
        void Add(T entity);
        T Get(Int32 entityId);
        void Remove(T entity);
        Int32 Count();
    }
}
