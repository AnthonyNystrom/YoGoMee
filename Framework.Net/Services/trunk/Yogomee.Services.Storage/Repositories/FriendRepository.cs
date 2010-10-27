using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Repositories;
using NHibernate;

namespace Yogomee.Services.Storage.Repositories
{
    public class FriendRepository : Repository<Friend>, IFriendRepository
    {
        public FriendRepository(ISession session)
            : base(session)
        {
        }

        public IEnumerable<Friend> GetFor(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            var query = Session.CreateQuery("from Friend friend where friend.Member1 = :member or friend.Member2 = :member");
            query.SetEntity("member", member);

            return query.List<Friend>();
        }
    }
}
