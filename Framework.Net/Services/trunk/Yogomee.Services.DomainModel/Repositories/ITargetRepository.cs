using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Repositories
{
    public interface ITargetRepository : IRepository<Target>
    {
        IEnumerable<Target> GetFor(Gomee gomee);
        IEnumerable<Target> GetFor(Member member);
    }
}
