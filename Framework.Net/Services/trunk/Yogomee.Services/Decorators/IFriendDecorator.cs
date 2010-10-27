using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.Decorators
{
    public interface IFriendDecorator : IDecorator<Friend>
    {
        Friend CreateFriend(Member member, Member friendMember);
        IEnumerable<Friend> GetFor(Member member);
    }
}
