using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Factories
{
    public class FriendFactory : IFriendFactory
    {

        public Friend CreateFriend(Member member1, Member member2)
        {
            if (member1 == null)
                throw new ArgumentNullException("member1");
            if (member2 == null)
                throw new ArgumentNullException("member2");

            return new Friend() 
            {
                Member1 = member1,
                Member2 = member2,
                Created = DateTime.Now
            };
        }
    }
}
