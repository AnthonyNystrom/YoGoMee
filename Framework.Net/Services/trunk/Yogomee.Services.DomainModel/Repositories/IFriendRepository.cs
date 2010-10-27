using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Repositories
{
    public interface IFriendRepository : IRepository<Friend>
    {
        IEnumerable<Friend> GetFor(Member member);
    }
}
