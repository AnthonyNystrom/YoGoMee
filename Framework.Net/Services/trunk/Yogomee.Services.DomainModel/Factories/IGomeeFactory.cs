using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Factories
{
    public interface IGomeeFactory
    {
        Gomee CreateGomee(Member member);
    }
}
