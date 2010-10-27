using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Yogomee.Services.DomainModel.Entities
{
    public class Friend
    {
        public virtual Int32 Id
        {
            get;
            private set;
        }

        public virtual Member Member1
        {
            get;
            internal set;
        }

        public virtual Member Member2
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
