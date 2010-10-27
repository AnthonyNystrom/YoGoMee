/* ------------------------------------------------
 * WebIdGenerator.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */
using System;
using System.Text;

namespace Genetibase.DomainModel
{
    public sealed class WebIdGenerator : IWebIdGenerator
    {
        public String NewWebId()
        {
            var guid = Guid.NewGuid().ToString().Replace("-", "");
            var bytes = Encoding.UTF8.GetBytes(guid);

            return Convert.ToBase64String(bytes).Substring(0, 8);
        }
    }
}
