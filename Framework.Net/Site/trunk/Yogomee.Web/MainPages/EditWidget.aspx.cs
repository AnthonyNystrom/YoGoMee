using System;
using System.IO;
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
using yoGomee.Data;
using yoGomee.Interpreter;

namespace yoGomee.MainPages
{
    public partial class EditWidget : System.Web.UI.Page
    {
        public YoGomeeUser user;
        public int WidgetID;

        protected void Page_Load(object sender, EventArgs e)
        {
            string strWidgetID = Request.Params["wid"];
            WidgetID = Int32.Parse(strWidgetID);

            user = (YoGomeeUser)Session["User"];

            if (user == null)
            {
                Response.Redirect("/login");
            }

            AjaxPro.Utility.RegisterTypeForAjax(typeof(EditWidget));
        }

        [AjaxPro.AjaxMethod]
        public string GetWidgetCode(int WidgetID)
        {
            user = (YoGomeeUser)Session["User"];

            FileManager fm = new FileManager(user.YoGomeeUserID);

            Widget widget = new Widget(WidgetID);

            string WidgetPath = fm.MyWidgetDir + @"\" + widget.WidgetFileName;

            StreamReader reader = File.OpenText(WidgetPath);

            string SampleCode = reader.ReadToEnd();

            reader.Close();

            return SampleCode;
        }

        [AjaxPro.AjaxMethod]
        public void SaveWidgetCode(string Code, int WidgetID)
        {
            user = (YoGomeeUser)Session["User"];

            FileManager fm = new FileManager(user.YoGomeeUserID);

            Widget widget = new Widget(WidgetID);

            string WidgetPath = fm.MyWidgetDir + @"\" + widget.WidgetFileName;

            StreamWriter writer = File.CreateText(WidgetPath);

            writer.Write(Code);
            writer.Flush();
            writer.Close();
        }

        [AjaxPro.AjaxMethod]
        public ExecutionResponse ExecuteCode(string Code, int WidgetID)
        {
            user = (YoGomeeUser)Session["User"];

            FileManager fm = new FileManager(user.YoGomeeUserID);

            Widget widget = new Widget(WidgetID);

            Code = RegexXMLFormat.Modify(Code);

            var Response = RunWidget.DebugWidget(Code, fm.MyWidgetDir, widget.WidgetFileName);

            return Response;
        } 
    }
}
