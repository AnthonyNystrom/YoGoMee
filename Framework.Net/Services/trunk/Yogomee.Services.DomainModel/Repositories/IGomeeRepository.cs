using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Repositories
{
    public interface IGomeeRepository : IRepository<Gomee>
    {
        IEnumerable<Gomee> GetMineFor(Member member);
        IEnumerable<Gomee> GetTheirsFor(Member member);
    }
}
