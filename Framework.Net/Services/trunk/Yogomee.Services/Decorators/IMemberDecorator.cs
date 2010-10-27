using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.Decorators
{
    public interface IMemberDecorator : IDecorator<Member>
    {
        Member CreateMember(String email);
        Member Get(String email);
    }
}
