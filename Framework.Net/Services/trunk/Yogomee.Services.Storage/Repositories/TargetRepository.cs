using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Repositories;
using NHibernate;
using NHibernate.Criterion;

namespace Yogomee.Services.Storage.Repositories
{
    public class TargetRepository : Repository<Target>, ITargetRepository
    {
        public TargetRepository(ISession session)
            : base(session)
        {
        }

        public IEnumerable<Target> GetFor(Gomee gomee)
        {
            if (gomee == null)
                throw new ArgumentNullException("gomee");

            var query = Session.CreateQuery("from Target target where target.Gomee = :gomee");
            query.SetEntity("gomee", gomee);

            return query.List<Target>();
        }

        public IEnumerable<Target> GetFor(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            var query = Session.CreateQuery("from Target target where target.Member = :member");
            query.SetEntity("member", member);

            return query.List<Target>();
        }
    }
}
