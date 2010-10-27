using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.Decorators
{
    public interface ITargetDecorator : IDecorator<Target>
    {
        Target CreateTarget(Member member, Gomee gomee);
        IEnumerable<Target> GetFor(Gomee gomee);
        IEnumerable<Target> GetFor(Member member);
    }
}
