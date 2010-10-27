using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Yogomee.Services.DomainModel.Repositories;

namespace Yogomee.Services.DomainModel
{
    public interface IUnitOfWork
    {
        IMemberRepository MemberRepository { get; }
        IFriendRepository FriendRepository { get; }
        IGomeeRepository GomeeRepository { get; }
        ITargetRepository TargetRepository { get; }

        void PersistAll();
        void Close();
    }
}
