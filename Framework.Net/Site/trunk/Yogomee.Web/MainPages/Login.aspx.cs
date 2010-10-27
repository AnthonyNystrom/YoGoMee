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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            YoGomeeUser user = YoGomeeUser.Login(txtEmail.Text, txtPassword.Text);

            if (user != null)
            {
                Session["User"] = user;
                Response.Redirect("/widgetstore");
            }
            else
            {
                lblMessage.Text = "invalid login details";
            }
            
        }
    }
}
