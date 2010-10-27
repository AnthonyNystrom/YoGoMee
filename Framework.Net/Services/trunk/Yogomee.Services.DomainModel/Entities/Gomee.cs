/* ------------------------------------------------
 * Gomee.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;

namespace Yogomee.Services.DomainModel.Entities
{
    public class Gomee
    {
        public virtual Int32 Id
        {
            get;
            private set;
        }

        public virtual Member Member
        {
            get;
            set;
        }

        public virtual String Caption
        {
            get;
            set;
        }

        public virtual String Address
        {
            get;
            set;
        }

        public virtual String Description
        {
            get;
            set;
        }

        public virtual Double Latitude
        {
            get;
            set;
        }

        public virtual Double Longitude
        {
            get;
            set;
        }

        public virtual Int32 GomeeType
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
