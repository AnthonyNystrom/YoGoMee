using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Repositories;
using System.Diagnostics;

namespace Yogomee.Services.Decorators
{
    public class FriendDecorator : Decorator<Friend>, IFriendDecorator
    {
        private IFriendFactory _factory;

        public FriendDecorator(
            IFriendFactory factory,
            IFriendRepository repository)
            : base(repository)
        {
            if (factory == null)
                throw new ArgumentNullException("factory");

            _factory = factory;
        }

        protected IFriendRepository FriendRepository
        {
            get
            {
                return Repository as IFriendRepository;
            }
        }

        public Friend CreateFriend(Member member, Member friendMember)
        {
            Debug.Assert(_factory != null, "factory != null");

            if (member == null)
                throw new ArgumentNullException("member");
            if (friendMember == null)
                throw new ArgumentNullException("friendMember");

            return _factory.CreateFriend(member, friendMember);
        }

        public IEnumerable<Friend> GetFor(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            return FriendRepository.GetFor(member);
        }
    }
}
