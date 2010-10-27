/* ------------------------------------------------
 * IMemberRepository.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Linq;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services.DomainModel.Repositories
{
    public interface IMemberRepository : IRepository<Member>
    {
        Member Get(String email);
    }
}
