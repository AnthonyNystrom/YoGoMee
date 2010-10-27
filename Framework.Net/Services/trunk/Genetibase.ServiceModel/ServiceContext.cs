/* ------------------------------------------------
 * ServiceContext.cs
 * Copyright © 2008 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel.Web;

namespace Genetibase.ServiceModel
{
    public class ServiceContext : IServiceContext
    {
        public const String TextHtml = "text/html";

        public String ContentType
        {
            get
            {
                return WebOperationContext.Current.OutgoingResponse.ContentType;
            }
            set
            {
                if (String.IsNullOrEmpty(value))
                    throw new ArgumentNullException("value");

                WebOperationContext.Current.OutgoingResponse.ContentType = value;
            }
        }
    }
}
