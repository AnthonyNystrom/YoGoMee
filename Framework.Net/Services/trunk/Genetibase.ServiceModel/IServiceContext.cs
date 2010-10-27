/* ------------------------------------------------
 * IServiceContext.cs
 * Copyright © 2008 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Genetibase.ServiceModel
{
    public interface IServiceContext
    {
        String ContentType { get; set; }
    }
}
