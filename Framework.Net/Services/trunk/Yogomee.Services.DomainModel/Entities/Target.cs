using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Yogomee.Services.DomainModel.Entities
{
    public class Target
    {
        public virtual Int32 Id
        {
            get;
            private set;
        }

        public virtual Member Member
        {
            get;
            internal set;
        }

        public virtual Gomee Gomee
        {
            get;
            internal set;
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
