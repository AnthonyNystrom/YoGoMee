using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.Decorators
{
    public interface IGomeeDecorator : IDecorator<Gomee>
    {
        Gomee CreateGomee(Member member);
        IEnumerable<Gomee> GetMineFor(Member member);
        IEnumerable<Gomee> GetTheirsFor(Member member);
    }
}
