using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Web.Routing;
using System.Reflection;
using yoGomee.Data;

namespace yoGomee
{
    public class WebUtility
    {
        public WebUtility()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            string Root = "";

            // user pages
            routes.Add(new Route(Root + "home/", new WebFormRouteHandler<Page>("~/MainPages/Index.aspx")));
            routes.Add(new Route(Root + "debug/", new WebFormRouteHandler<Page>("~/MainPages/DebugYGML.aspx")));
            routes.Add(new Route(Root + "login/", new WebFormRouteHandler<Page>("~/MainPages/Login.aspx")));
            routes.Add(new Route(Root + "widgetstore/", new WebFormRouteHandler<Page>("~/MainPages/WidgetStore.aspx")));
            routes.Add(new Route(Root + "mywidgets/", new WebFormRouteHandler<Page>("~/MainPages/MyWidgets.aspx")));
            routes.Add(new Route(Root + "newwidget/", new WebFormRouteHandler<Page>("~/MainPages/NewWidget.aspx")));
            routes.Add(new Route(Root + "editwidget/", new WebFormRouteHandler<Page>("~/MainPages/EditWidget.aspx")));
            routes.Add(new Route(Root + "widgetsettings/", new WebFormRouteHandler<Page>("~/MainPages/WidgetSettings.aspx")));

            

            
        }

        //public static yoGomeeUser GetCurrentUser()
        //{
        //    yoGomeeUser CurrentUser = (SystemUser)HttpContext.Current.Session["CurrentUser"];

        //    if (CurrentUser == null)
        //    {
        //        CurrentUser = new yoGomeeUser(1);
        //        HttpContext.Current.Session.Add("CurrentUser", CurrentUser);
        //    }

        //    return CurrentUser;
        //}
    }
}
