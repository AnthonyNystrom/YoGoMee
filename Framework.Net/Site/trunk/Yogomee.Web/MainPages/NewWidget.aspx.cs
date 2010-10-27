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
using yoGomee.Data;

namespace yoGomee.MainPages
{
    public partial class NewWidget : System.Web.UI.Page
    {
        public YoGomeeUser user;
       
        

        protected void Page_Load(object sender, EventArgs e)
        {
            user = (YoGomeeUser)Session["User"];

            if (user == null)
            {
                Response.Redirect("/login");
            }

        }

        protected void btnNew_Click(object sender, EventArgs e)
        {
            user = (YoGomeeUser)Session["User"];

            Widget widget = new Widget();
            widget.Name = txtName.Text;
            widget.Description = txtDescription.Text;

            widget.SaveNewWidget(user);

            Response.Redirect("/editwidget/?wid=" + widget.WidgetID);
        }
    }
}
