using System;
using System.Collections.Generic;
using System.Net;
using System.Web;

namespace Yogomee.Services.Integration
{
    public class MyspaceImporter : ContactImporter
    {
        private String myToken = "";
        private String reffer = "";
        private String addressBookURL = "";
        private String htmlResponse = "";
        private String postString = "";
        private HttpUtils httpUtils = null;

        public MyspaceImporter()
        {
            httpUtils = new HttpUtils();
        }
        public MyspaceImporter(String user, String pass) : base(user, pass)
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
            String homePage = "http://www.myspace.com";
            String loginUrl = "http://login.myspace.com/index.cfm?fuseaction=login.process&MyToken=";
            try
            {
                htmlResponse = httpUtils.GetHttpResponse(homePage, false);
                reffer = homePage;
                String tempStr = "MyToken=";
                int pos = htmlResponse.IndexOf(tempStr);
                myToken = htmlResponse.Substring(pos + tempStr.Length);
                myToken = myToken.Substring(0, myToken.IndexOf("\""));
                loginUrl += myToken;
                postString = "email=" + UserId + "&password=" + HttpUtility.UrlEncode(Password) + "&Submit22_x=33&Submit22_y=10";
                htmlResponse = httpUtils.GetHttpResponse(loginUrl, false, postString, reffer);
                if (htmlResponse.IndexOf("<input type=\"text\" name=\"email\"") == -1)
                {
                    // Begin Outer If
                    if (htmlResponse.IndexOf("Member Login") == -1)
                    {
                        // Begin 1st inner if
                        if (htmlResponse.IndexOf("Skip this Advertisement") > 1)
                        {
                            htmlResponse = htmlResponse.Substring(0, htmlResponse.IndexOf("Skip this Advertisement"));
                            tempStr = "<a href=\"";
                            String urlToFetch = htmlResponse.Substring(htmlResponse.IndexOf(tempStr) + tempStr.Length);
                            urlToFetch = urlToFetch.Substring(0, urlToFetch.IndexOf("\""));
                            htmlResponse = httpUtils.GetHttpResponse(urlToFetch, false, "", loginUrl);

                        }
                        //End 1st inner if.

                        // Begin of 2nd inner if
                        if (htmlResponse.IndexOf("You have\n <span><a href=\"") == -1)
                        {
                            htmlResponse = httpUtils.GetHttpResponse("http://home.myspace.com/index.cfm?fuseaction=user", false);

                        }
                        // End of 2nd inner if
                        tempStr = "<span><a href=\"";
                        String fPage = htmlResponse.Substring(htmlResponse.IndexOf(tempStr) + tempStr.Length);
                        fPage = fPage.Substring(0, fPage.IndexOf("\""));

                        IsLoggedIn = true;
                    }
                }
                else
                {
                    IsLoggedIn = false;
                }
            }
            //Outer if close
            // End of outer if
            catch (Exception)
            {
                IsLoggedIn = false;
            }
            return IsLoggedIn;
        }

        public override bool ImportContacts()
        {
            Contacts = new List<Contact>();
            string[] nameArray = null;
            string[] emailArray = null;
            string[] rows = null;
            string[] colums = null;
            //int i = 0;
            addressBookURL = "http://addressbook.myspace.com/index.cfm?fuseaction=adb&MyToken=" + myToken;

            try
            {
                htmlResponse = httpUtils.GetHttpResponse(addressBookURL, false);
                String addTable = htmlResponse.Substring(htmlResponse.IndexOf("<table id=\"addresses\""));
                addTable = addTable.Substring(0, addTable.IndexOf("</table"));
                rows = StringUtils.Split(addTable, "</tr>");
                nameArray = new string[rows.Length];
                emailArray = new string[rows.Length];
                for (int i = 1; i < rows.Length - 1; i++)
                {
                    colums = StringUtils.Split(rows[i], "</td>");
                    nameArray[i] = StringUtils.StripTags(colums[1]).TrimStart();
                    emailArray[i] = StringUtils.StripTags(colums[2]).TrimStart();
                    if (((nameArray[i] == null) || nameArray[i].Equals("")) || ((emailArray[i] == null) || emailArray[i].Equals("")))
                    {
                        continue;
                    }
                    else
                    {
                        Contacts.Add(new Contact { Name = nameArray[i], Email = emailArray[i], Source = "Myspace" });                        
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

            catch (WebException)
            {
                Logout();
                return false;
            }

        }
    }
}
