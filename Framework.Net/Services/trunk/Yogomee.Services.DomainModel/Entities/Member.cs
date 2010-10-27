/* ------------------------------------------------
 * Member.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Yogomee.Services.DomainModel.Entities
{
    public class Member
    {
        public virtual Int32 Id
        {
            get;
            private set;
        }

        public virtual String Email
        {
            get;
            internal set;
        }

        public virtual String Password
        {
            get;
            set;
        }

        public virtual DateTime Created
        {
            get;
            internal set;
        }

        public virtual Int32 Version
        {
            get;
            internal set;
        }
    }
}
