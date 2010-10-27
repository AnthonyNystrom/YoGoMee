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
    public partial class WidgetStore : System.Web.UI.Page
    {
        public string WidgetListerHTML = string.Empty;
        public YoGomeeUser user;

        protected void Page_Load(object sender, EventArgs e)
        {
            AjaxPro.Utility.RegisterTypeForAjax(typeof(WidgetStore));

            user = (YoGomeeUser)Session["User"];

            if (user == null)
            {
                Response.Redirect("/login");
            }


            GenerateAppLister();
        }

        private void GenerateAppLister()
        {
            List<Widget> AllWidgets = Widget.GetAllWidget();

            List<InstalledWidget> InstalledWidgets = InstalledWidget.GetAllInstalledWidgetByUserID(user.YoGomeeUserID);

            var objects =   from w in AllWidgets
                            join i in InstalledWidgets on w.WidgetID equals i.WidgetID into iw
                            from i in iw.DefaultIfEmpty(new InstalledWidget())
                            select new { Name = w.Name, WidgetID = w.WidgetID, InstalledWidgetID = i.InstalledWidgetID };


            var List = objects.ToList();


            for (int i = 0; i < AllWidgets.Count; i++)
            {

                if (List[i].InstalledWidgetID > 0)
                {
                    WidgetListerHTML += String.Format("<div>{0} - <a class='pointer' onclick='uninstall({1})'>uninstall</a></div></br>", List[i].Name, List[i].InstalledWidgetID);
                }
                else
                {
                    WidgetListerHTML += String.Format("<div>{0} - <a class='pointer' onclick='install({1})'>install</a></div></br>", List[i].Name, List[i].WidgetID);
                }
                

                
            }

        }


    }
}
