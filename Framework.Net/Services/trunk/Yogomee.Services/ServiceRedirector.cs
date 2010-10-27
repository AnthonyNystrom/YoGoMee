/* ------------------------------------------------
 * File: ServiceRedirector.cs
 * 
 * Created: 2/17/2009
 * Modified: 2/17/2009
 * 
 * Copyright © Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Yogomee.Services
{
    /// <summary>
    /// Allows to access WCF services omitting SVC extension.
    /// </summary>
    public class ServiceRedirector : IHttpModule
    {
        private static List<String> _serviceMap = new List<String> 
        {
        };

        public void Dispose()
        {
        }

        public void Init(HttpApplication context)
        {
            context.BeginRequest += (sender, e) =>
            {
                var ctx = HttpContext.Current;
                var path = ctx.Request.AppRelativeCurrentExecutionFilePath.ToLower();

                foreach (var mapPath in _serviceMap)
                {
                    if (path.Contains("/" + mapPath + "/") || path.EndsWith("/" + mapPath))
                    {
                        var newPath = path.Replace("/" + mapPath + "/", "/" + mapPath + ".svc/");
                        ctx.RewritePath(newPath, null, ctx.Request.QueryString.ToString(), false);
                        return;
                    }
                }
            };
        }
    }
}
