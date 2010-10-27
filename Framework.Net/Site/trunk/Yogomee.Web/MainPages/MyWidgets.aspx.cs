using System;
using System.IO;
using System.Collections.Generic;
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
using yoGomee.Data;

namespace yoGomee.MainPages
{
    public partial class MyWidgets : System.Web.UI.Page
    {
        public string MyWidgetsListerHTML = string.Empty;
        public string InstalledWidgetsListerHTML = string.Empty;
        public YoGomeeUser user;

        protected void Page_Load(object sender, EventArgs e)
        {
            AjaxPro.Utility.RegisterTypeForAjax(typeof(MyWidgets));

            user = (YoGomeeUser)Session["User"];

            if (user == null)
            {
                Response.Redirect("/login");
            }


            GenerateAppLister();
        }

       [AjaxPro.AjaxMethod]
        public void UpdateWidget(int InstalledWidgetID)
        {
            user = (YoGomeeUser)Session["User"];

            InstalledWidget iWidget = new InstalledWidget(InstalledWidgetID);

            iWidget.OriginalWidget.UpdateInstallWidget(user);

        }
        

        private void GenerateAppLister()
        {
            user = (YoGomeeUser)Session["User"];

            List<Widget> MyWidgets = Widget.GetAllWidgetByUserID(user.YoGomeeUserID);

            for (int i = 0; i < MyWidgets.Count; i++)
            {
                MyWidgetsListerHTML += String.Format("<div>{0} - <a href='/editwidget/?wid={1}'>edit</a></div></br>", MyWidgets[i].Name, MyWidgets[i].WidgetID);
            }

            List<InstalledWidget> InstalledWidgets = InstalledWidget.GetAllInstalledWidgetByUserID(user.YoGomeeUserID);

            for (int i = 0; i < InstalledWidgets.Count; i++)
            {
                string DisableText = (InstalledWidgets[i].Enabled) ? "disable" : "enable";

                InstalledWidgetsListerHTML += String.Format(@"<div>{0} - <a class='pointer' onclick ='showSettings({1})'>settings</a> | 
                                                                         <a class='pointer' onclick ='updateWidget({1})'>Get latest version</a> | 
                                                                         <a class='pointer' onclick ='disable({1},{2})'>{3}</a> | 
                                                                         <a class='pointer' onclick ='uninstall({1})'>uninstall</a></div></br>", 
                    InstalledWidgets[i].OriginalWidget.Name, 
                    InstalledWidgets[i].InstalledWidgetID, 
                    (!InstalledWidgets[i].Enabled).ToString().ToLower(),
                    DisableText);
            }

        }


    }
}
