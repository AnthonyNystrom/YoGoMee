using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Xml.Linq;
using System.Web.Routing;
using System.Security.Principal;


namespace yoGomee
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            WebUtility.RegisterRoutes(RouteTable.Routes);
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            string QueryString = Request.Url.PathAndQuery;

            bool SetCacheHeader = false;

            if (QueryString.Contains(".js") || QueryString.Contains(".css"))
            {
                SetCacheHeader = true;
            }
            else if (QueryString.Contains("img/"))
            {
                SetCacheHeader = true;
            }
            else if (QueryString.Contains("prototype.ashx") || QueryString.Contains("core.ashx") || QueryString.Contains("ms.ashx") || QueryString.Contains("converter.ashx"))
            {
                SetCacheHeader = true;
            }

            if (SetCacheHeader)
            {
                Response.Cache.AppendCacheExtension("post-check=100000,pre-check=600000");
                Response.Cache.SetMaxAge(new TimeSpan(2, 0, 0, 0));
                //Response.Cache.SetETagFromFileDependencies();
                //Response.Cache.SetLastModifiedFromFileDependencies();
            }
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}