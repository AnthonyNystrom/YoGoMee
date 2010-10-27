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
using Yogomee.Services.Storage.Repositories;

namespace Yogomee.Services.Storage.Repositories
{
    public class MemberRepository : Repository<Member>, IMemberRepository
    {
        public MemberRepository(ISession session)
            : base(session)
        {
        }

        public Member Get(String email)
        {
            if (email == null)
                throw new ArgumentNullException("email");

            var query = Session.CreateQuery("from Member member where member.Email = :email");
            query.SetString("email", email);

            if(query.List().Count == 0)
                throw new ArgumentException(
                    String.Format(
                        CultureInfo.InvariantCulture,
                        Resources.EntityNotExists_String,
                        typeof(Member).Name),
                    email);

            return query.UniqueResult<Member>();
        }

        public override void Add(Member entity)
        {
            if (entity == null)
                throw new ArgumentNullException("entity");

            var query = Session.CreateQuery("select count(*) from Member member where member.Email = :email");
            query.SetString("email", entity.Email);

            if (query.UniqueResult<Int64>() > 0)
            {
                throw new ArgumentException(
                    String.Format(
                        CultureInfo.InstalledUICulture,
                        Resources.EntityExists_String,
                        "Member"),
                    entity.Email);
            }

            base.Add(entity);
        }
    }
}
