using System;
using System.Text;
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

namespace yoGomee
{
    public partial class Index : System.Web.UI.Page
    {
        public YoGomeeUser YoGomeeUser;

        protected void Page_Load(object sender, EventArgs e)
        {
            YoGomeeUser = (YoGomeeUser)Session["User"];

            if (YoGomeeUser == null)
            {
                Response.Redirect("/login");
            }
        }

    }
}