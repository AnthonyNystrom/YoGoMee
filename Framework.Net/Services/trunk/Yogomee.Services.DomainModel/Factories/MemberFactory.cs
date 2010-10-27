/* ------------------------------------------------
 * MemberFactory.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using Yogomee.Services.DomainModel.Entities;
using System.Collections.Generic;
using Iesi.Collections.Generic;
using System;

namespace Yogomee.Services.DomainModel.Factories
{
    public class MemberFactory : IMemberFactory
    {
        public Member CreateMember(String email)
        {
            if (String.IsNullOrEmpty(email))
                throw new ArgumentNullException("email");

            return new Member()
            {
                Email = email,
                Password = "secret",
                Created = DateTime.Now
            };
        }
    }
}
