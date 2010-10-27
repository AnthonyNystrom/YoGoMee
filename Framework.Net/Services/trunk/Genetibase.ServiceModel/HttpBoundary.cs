/* ------------------------------------------------
 * HttpBoundary.cs
 * Copyright © 2008 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;

namespace Genetibase.ServiceModel
{
    public class HttpBoundary
    {
        public HttpBoundary()
        {
            Parameters = new List<HttpDispositionParameter>();
        }

        public String ContentType { get; set; }
        public String DispositionType { get; set; }
        public IList<HttpDispositionParameter> Parameters { get; private set; }
        public String Value { get; set; }
    }
}
