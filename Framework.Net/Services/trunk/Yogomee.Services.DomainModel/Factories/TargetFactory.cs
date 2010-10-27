using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Factories
{
    public class TargetFactory : ITargetFactory
    {
        public Target CreateGomeeTarget(Member member, Gomee gomee)
        {
            if (member == null)
                throw new ArgumentNullException("member");
            if (gomee == null)
                throw new ArgumentNullException("gomee");

            return new Target() 
            {
                Member = member,
                Gomee = gomee,
                Created = DateTime.Now
            };
        }
    }
}
