using System;
using System.Collections.Generic;
using System.Web;

namespace YGMEUserContactAccessAPI
{
    public class GmailImporter : ContactImporter
    {
        private HttpUtils httpUtils = null;

        public GmailImporter()
        {
            httpUtils = new HttpUtils();
        }

        public GmailImporter(String userId, String password) : base(userId, password)
        {            
            httpUtils = new HttpUtils();
        }

        public override bool RequiresManualLogin
        {
            get { return false; }
        }

        public override bool DoLogin()
        {
            Logout(true);

            String htmlResponse = "", postString;
            String startUrl = "http://www.gmail.com/";
            String nextUrl, referrer;
            try
            {
                htmlResponse = httpUtils.GetHttpResponse(startUrl, false);
                referrer = "https://www.google.com/accounts/ServiceLogin?service=mail&passive=true&rm=false&continue=http%3A%2F%2Fmail.google.com%2Fmail%2F%3Fui%3Dhtml%26zy%3Dl";
                nextUrl = "https://www.google.com/accounts/ServiceLoginAuth";
                postString = "rm=false&service=mail&Email=" + HttpUtility.UrlEncode(UserId) + "&Passwd=" + HttpUtility.UrlEncode(Password) + "&null=Sign%20in&continue=http%3A%2F%2Fmail.google.com%2Fgmail/?";
                htmlResponse = httpUtils.GetHttpResponse(nextUrl, false, postString, referrer);
                if (htmlResponse.IndexOf("errormsg") == -1)
                {
                    IsLoggedIn = true;
                }
                else
                    IsLoggedIn = false;
            }
            catch (Exception)
            {
                // Console.WriteLine("Exception occured in DoLogin : " + e.Message );
            }
            return IsLoggedIn;
        }

        public override bool ImportContacts()
        {
            String adrUrl, referrer, htmlResponse;            
            Contacts = new List<Contact>();
            string name;
            string email;
            adrUrl = "http://mail.google.com/mail/contacts/data/contacts?thumb=true&groups=true&show=ALL&psort=Name&max=100000&out=js&rf=&jsx=true";
            referrer = "http://mail.google.com/mail/contacts/ui/ContactManager?js=RAW";
            htmlResponse = httpUtils.GetHttpResponse(adrUrl, false, "", referrer);
            string str1 = htmlResponse.Substring(htmlResponse.IndexOf("\"Contacts\""));
            str1 = str1.Substring(0, str1.IndexOf("\"Groups\":[{\"Count\":"));
            string[] lines;
            lines = StringUtils.Split(str1, "\"Affinity\"");
            string tempstr;
            foreach (string s in lines)
            {
                if (s.IndexOf("\"Address\":\"") == -1)
                {
                    continue;
                }
                tempstr = s.Substring(s.IndexOf("\"Address\":\"") + "\"Address\":\"".Length);
                email = tempstr.Substring(0, tempstr.IndexOf("\""));
                email = email.Replace("\\u0027", "'");
                if (s.IndexOf("\"FullName\":{\"Unstructured\":\"") == -1)
                {
                    name = email.Substring(0, email.IndexOf("@"));
                }
                else
                {
                    tempstr = s.Substring(s.IndexOf("\"FullName\":{\"Unstructured\":\"") + "\"FullName\":{\"Unstructured\":\"".Length);
                    name = tempstr.Substring(0, tempstr.IndexOf("\""));
                    name = name.Replace("\\u0027", "'");
                    name = name.Replace("\\u0022", "\"");
                    name = name.Replace("\\u003D", "=");
                    name = name.Replace("\\u0026", "&");
                }

                Contacts.Add(new Contact(name, email, ContactSource.GmailContactSource));                
            }

            if (Contacts.Count > 0)
                return true;
            return false;
        }
    }
}
