using System;
using System.Collections.Generic;
using System.Web;

namespace Yogomee.Services.Integration
{
    public class LinkedInImporter : ContactImporter
    {
        private String reffer = "";
        private String htmlResponse = "";
        private String postString = "";
        public String captcha = "";
        private String jsessionid = "";
        private HttpUtils httpUtils = null;

        public LinkedInImporter()
        {
            httpUtils = new HttpUtils();
        }

        public LinkedInImporter(String user, String pass) : base(user, pass)
        {
            httpUtils = new HttpUtils();
        }

        public override Boolean RequiresManualLogin
        {
            get { return false; }
        }
        
        public override Boolean DoLogin()
        {
            Logout(true);
            String loginUrl = "https://www.linkedin.com/secure/login";
            try
            {
                htmlResponse = httpUtils.GetHttpResponse(loginUrl, true);
                this.jsessionid = htmlResponse.Substring(htmlResponse.IndexOf("JSESSIONID=") + "JSESSIONID=".Length);
                this.jsessionid = this.jsessionid.Substring(0, this.jsessionid.IndexOf(";"));
                postString = "session_key=" + UserId + "&session_password=" + HttpUtility.UrlEncode(Password) + "&session_login=Sign In&session_login=&session_rikey=invalid key&session_login.x=0&session_login.y=0";
                reffer = loginUrl;
                htmlResponse = httpUtils.GetHttpResponse(loginUrl, true, postString, reffer);
                if (htmlResponse.IndexOf("<input type=\"text\" name=\"session_key\"") == -1)
                {
                    IsLoggedIn = true;
                    String homePage = htmlResponse.Substring(htmlResponse.IndexOf("window.location.replace('") + "window.location.replace('".Length);
                    homePage = homePage.Substring(0, homePage.IndexOf("'"));
                    htmlResponse = httpUtils.GetHttpResponse(homePage, true);
                }
                else
                {
                    IsLoggedIn = false;
                }
            }
            catch (Exception)
            {
                Logout();
                IsLoggedIn = false;
            }
            return IsLoggedIn;
        }

        //Calculate Unix TimeStamp
        private static Int64 utimestamp()
        {
            System.DateTime UnixBase = new System.DateTime(1970, 1, 1, 0, 0, 0, 0);
            System.DateTime dtm = System.DateTime.Now;
            return (((Int64)dtm.Subtract(UnixBase).TotalSeconds) * 999);
        }
        //End Unix TimeStamp

        public override Boolean ImportContacts()
        {
            this.Contacts = new List<Contact>();            

            String[] nameArray = null;
            String[] emailArray = null;
            String[] rows = null;
            String contactsUrl = "http://www.linkedin.com/dwr/exec/ConnectionsBrowserService.getMyConnections.dwr";
            String contacts = "";
            String addressUrl = "http://www.linkedin.com/connections?trk=hb_side_cnts";
            try
            {
                htmlResponse = httpUtils.GetHttpResponse(addressUrl, true);

                Random r = new Random();
                String number = r.Next(1, 9999).ToString("0000");
                String cid = number + "_" + utimestamp();

                postString = "callCount=1&JSESSIONID=" + this.jsessionid + "&c0-scriptName=ConnectionsBrowserService&c0-methodName=getMyConnections&c0-id=" + cid + "&c0-param0=number:-1&c0-param1=number:-1&c0-param2=String:DONT_CARE&c0-param3=number:500&c0-param4=boolean:false&c0-param5=boolean:true&xml=true";
                htmlResponse = httpUtils.GetHttpResponse(contactsUrl, false, postString, addressUrl, "text/plain");
                contacts = htmlResponse.Substring(htmlResponse.IndexOf("s0.lastInitial"));
                contacts = contacts.Substring(0, contacts.IndexOf("s0.myConnections"));
                rows = StringUtils.Split(contacts, "browseConnectionsLink");
                nameArray = new String[rows.Length];
                emailArray = new String[rows.Length];
                for (Int32 i = 1; i < rows.Length; i++)
                {
                    String emailAddress = "", firstName = "", lastName = "", tmpEmail = "", tmpFName = "", tmpLName = "", tmpName = "";
                    emailAddress = rows[i].Substring(rows[i].IndexOf("emailAddress=") + "emailAddress=".Length);
                    emailAddress = emailAddress.Substring(0, emailAddress.IndexOf(";"));
                    emailAddress = emailAddress + "=\"";

                    tmpEmail = rows[i].Substring(rows[i].IndexOf(emailAddress) + emailAddress.Length);
                    tmpEmail = tmpEmail.Substring(0, tmpEmail.IndexOf("\""));

                    firstName = rows[i].Substring(rows[i].IndexOf("firstName=") + "firstName=".Length);
                    firstName = firstName.Substring(0, firstName.IndexOf(";"));
                    firstName = firstName + "=\"";

                    tmpFName = rows[i].Substring(rows[i].IndexOf(firstName) + firstName.Length);
                    tmpFName = tmpFName.Substring(0, tmpFName.IndexOf("\""));

                    lastName = rows[i].Substring(rows[i].IndexOf("lastName=") + "lastName=".Length);
                    lastName = lastName.Substring(0, lastName.IndexOf(";"));
                    lastName = lastName + "=\"";

                    tmpLName = rows[i].Substring(rows[i].IndexOf(lastName) + lastName.Length);
                    tmpLName = tmpLName.Substring(0, tmpLName.IndexOf("\""));

                    tmpName = tmpFName + " " + tmpLName;
                    if (tmpName == "" && !StringUtils.IsValidEmail(tmpEmail))
                    {
                        tmpName = tmpEmail.Substring(0, tmpEmail.IndexOf("@"));
                    }
                    nameArray[i] = tmpName;
                    emailArray[i] = tmpEmail;
                    if (((nameArray[i] == null) || nameArray[i].Equals("")) || ((emailArray[i] == null) || emailArray[i].Equals("")))
                    {
                        continue;
                    }
                    else
                    {
                        Contacts.Add(new Contact { Name = nameArray[i], Email = emailArray[i], Source = "LinkedIn" });                        
                    }

                }
                if (Contacts.Count > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception)
            {
                Logout(true);
                return false;
            }
        }
    }
}
