using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Factories
{
    public class GomeeFactory : IGomeeFactory
    {
        public Gomee CreateGomee(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            return new Gomee()
            {
                Member = member,
                Caption = "",
                Address = "",
                Description = "",
                Created = DateTime.Now
            };
        }
    }
}
