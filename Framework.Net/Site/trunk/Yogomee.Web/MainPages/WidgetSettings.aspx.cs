using System;
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
using yoGomee.Interpreter;

namespace yoGomee.MainPages
{
    public partial class WidgetSettings : System.Web.UI.Page
    {
        public InstalledWidget InstalledWidget;
        public string UIFieldsHTML = string.Empty;
        public string InstalledWidgetID;
        public YoGomeeUser user;
        public string WidgetName = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            AjaxPro.Utility.RegisterTypeForAjax(typeof(WidgetSettings));

            InstalledWidgetID = Request.Params["instw"];
            int intInstalledWidgetID = Int32.Parse(InstalledWidgetID);
            InstalledWidget = new InstalledWidget(intInstalledWidgetID);
            WidgetName = InstalledWidget.OriginalWidget.Name;

            List<Variable> UIFieldVariables = RunWidget.GetInputParameters(InstalledWidget);

            for (int i = 0; i < UIFieldVariables.Count; i++)
            {
                UIFieldsHTML += String.Format("<p>{0} <input class='widgetField' type='text' value='{1}'></p>", UIFieldVariables[i].Name, UIFieldVariables[i].Value.ToString());
            }
        }

        [AjaxPro.AjaxMethod]
        public void SaveInputParameters(int InstalledWidgetID, Object[] InputParams)
        {
            user = (YoGomeeUser)Session["User"];

            InstalledWidget widget = new InstalledWidget(InstalledWidgetID);
            Interpreter.RunWidget.SaveInputParameters(widget, InputParams);
            

        }


    }
}
