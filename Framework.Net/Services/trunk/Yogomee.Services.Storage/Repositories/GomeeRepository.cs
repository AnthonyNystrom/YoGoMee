using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Repositories;
using Yogomee.Services.DomainModel.Entities;
using NHibernate;
using System.Globalization;
using Yogomee.Services.Storage.Properties;
using NHibernate.Criterion;

namespace Yogomee.Services.Storage.Repositories
{
    public class GomeeRepository : Repository<Gomee>, IGomeeRepository
    {
        public GomeeRepository(ISession session)
            : base(session)
        {
        }

        public IEnumerable<Gomee> GetMineFor(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            var query = Session.CreateQuery("from Gomee gomee where gomee.Member = :member");
            query.SetEntity("member", member);
            return query.List<Gomee>();
        }

        public IEnumerable<Gomee> GetTheirsFor(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            var query = Session.CreateQuery("select distinct target.Gomee from Target target where target.Member = :member and target.Gomee.Member != :member");
            query.SetEntity("member", member);

            return query.List<Gomee>();
        }
    }
}
