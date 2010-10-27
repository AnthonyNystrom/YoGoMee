using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Security.Principal;
using yoGomee.Data;

namespace yoGomee
{
    public partial class Main : System.Web.UI.MasterPage
    {
        public YoGomeeUser user;
        public bool IsLoggedIn;

        protected void Page_Load(object sender, EventArgs e)
        {
            user = (YoGomeeUser)Session["User"];

            if (user != null)
            {
                IsLoggedIn = true;
            }

            AjaxPro.Utility.RegisterTypeForAjax(typeof(Main));

        }


        protected void btnNewWidget_Click(object sender, EventArgs e)
        {
            Response.Redirect("/newwidget");
        }

        protected void btnMyWidgets_Click(object sender, EventArgs e)
        {
            Response.Redirect("/mywidgets");
        }

        protected void btnWidgetStore_Click(object sender, EventArgs e)
        {
            Response.Redirect("/widgetstore");
        }

        [AjaxPro.AjaxMethod]
        public void InstallWidget(int WidgetID)
        {
            user = (YoGomeeUser)Context.Session["User"];

            Widget widget = Widget.LoadWidget(WidgetID);
            widget.InstallWidget(user);
        }

        [AjaxPro.AjaxMethod]
        public void UninstallWidget(int InstalledWidgetID)
        {
            user = (YoGomeeUser)Context.Session["User"];

            InstalledWidget.Delete(InstalledWidgetID);
        }

        [AjaxPro.AjaxMethod]
        public void DisableInstalledWidget(int InstalledWidgetID, bool Enable)
        {
            user = (YoGomeeUser)Context.Session["User"];

            InstalledWidget iw = new InstalledWidget(InstalledWidgetID);
            iw.Enabled = Enable;
            iw.Save();
        }


        

    

    }
}
