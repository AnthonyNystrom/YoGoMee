/* ------------------------------------------------
 * IMemberFactory.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using Yogomee.Services.DomainModel.Entities;
using System;

namespace Yogomee.Services.DomainModel.Factories
{
    public interface IMemberFactory
    {
        Member CreateMember(String email);
    }
}
