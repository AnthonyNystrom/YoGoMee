using System;
using System.Collections.Generic;
using System.Web;
using System.Net;

namespace Yogomee.Services.Integration
{
    public class HotmailImporter : ContactImporter
    {
        private String htmlResponse = "";
        private String postString = "";
        private String domain = "";
        private String n = "";
        private String mt = "";
        private WinHttpUtils httpUtils = null;

        public HotmailImporter()
        {
            httpUtils = new WinHttpUtils();
        }

        public HotmailImporter(String user, String pass) : base(user, pass)
        {
            httpUtils = new WinHttpUtils();
        }

        public override Boolean RequiresManualLogin
        {
            get { return false; }
        }
        
        public override Boolean DoLogin()
        {
            String startUrl = "http://login.live.com/login.srf?id=2&rru=%2fcgi%2dbin%2fhmhome%3ffti%3dyes&reason=nocookies";
            String loginUrl;
            String frm;
            String hiddenField;
            String redirectUrl;
            try
            {
                htmlResponse = httpUtils.GetHttpResponse(startUrl, false);
                frm = htmlResponse.Substring(htmlResponse.IndexOf("action=\"") + "action=\"".Length);
                loginUrl = frm.Substring(0, frm.IndexOf("\""));
                frm = frm.Substring(0, frm.IndexOf("</form>"));
                hiddenField = StringUtils.HiddenFields(frm);
                hiddenField = hiddenField.Replace("PwdPad=", "PwdPad=IfYouAreReadingThisYouHaveTooMuchF");
                postString = hiddenField + "&login=" + this.UserId + "&passwd=" + HttpUtility.UrlEncode(this.Password) + "&LoginOptions=3";
                htmlResponse = httpUtils.GetHttpResponse(loginUrl, false, postString, startUrl);
                if (htmlResponse.IndexOf("window.location.replace(\"") != -1)
                {
                    redirectUrl = htmlResponse.Substring(htmlResponse.IndexOf("window.location.replace(\"") + "window.location.replace(\"".Length);
                    redirectUrl = redirectUrl.Substring(0, redirectUrl.IndexOf("\")"));
                    htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true, "", "", false);
                    if (htmlResponse.IndexOf("Location:") != -1)
                    {
                        redirectUrl = htmlResponse.Substring(htmlResponse.IndexOf("Location: ") + "Location: ".Length);
                        redirectUrl = redirectUrl.Substring(0, redirectUrl.IndexOf("\r\n"));
                        this.domain = redirectUrl.Substring(redirectUrl.IndexOf("http://") + "http://".Length);
                        this.domain = this.domain.Substring(0, this.domain.IndexOf("/"));
                        htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true, "", "", false);
                        if (htmlResponse.IndexOf("Location:") != -1)
                        {
                            redirectUrl = htmlResponse.Substring(htmlResponse.IndexOf("Location: ") + "Location: ".Length);
                            redirectUrl = redirectUrl.Substring(0, redirectUrl.IndexOf("\r\n"));
                            if (htmlResponse.IndexOf("mt") != -1)
                            {
                                this.mt = htmlResponse.Substring(htmlResponse.IndexOf("mt=") + "mt=".Length);
                                this.mt = this.mt.Substring(0, this.mt.IndexOf(";"));
                            }
                            htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true, "", "", false);
                            if (htmlResponse.IndexOf("Location:") != -1)
                            {
                                redirectUrl = htmlResponse.Substring(htmlResponse.IndexOf("Location: ") + "location: ".Length);
                                redirectUrl = redirectUrl.Substring(0, redirectUrl.IndexOf("\r\n"));
                                this.n = redirectUrl.Substring(redirectUrl.IndexOf("n=") + "n=".Length);
                                htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true);
                                if (htmlResponse.IndexOf("mt") != -1)
                                {
                                    this.mt = htmlResponse.Substring(htmlResponse.IndexOf("mt=") + "mt=".Length);
                                    this.mt = this.mt.Substring(0, this.mt.IndexOf(";"));
                                }
                                if (htmlResponse.IndexOf("Location:") != -1)
                                {
                                    redirectUrl = htmlResponse.Substring(htmlResponse.IndexOf("Location: ") + "location: ".Length);
                                    redirectUrl = redirectUrl.Substring(0, redirectUrl.IndexOf("\r\n"));
                                    htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true);
                                    frm = htmlResponse.Substring(htmlResponse.IndexOf("action=\"") + "action=\"".Length);
                                    redirectUrl = frm.Substring(0, frm.IndexOf("\""));
                                    redirectUrl = redirectUrl.Replace("&amp;", "&");
                                    redirectUrl = "http://" + this.domain + "/mail/" + redirectUrl;
                                    frm = frm.Substring(0, frm.IndexOf("</form>"));
                                    hiddenField = StringUtils.HiddenFields(frm);
                                    postString = hiddenField + "&TakeMeToInbox=Continue";
                                    htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true, postString, "", true);
                                    if (htmlResponse.IndexOf("Location:") != -1)
                                    {
                                        redirectUrl = htmlResponse.Substring(htmlResponse.IndexOf("Location: ") + "location: ".Length);
                                        redirectUrl = redirectUrl.Substring(0, redirectUrl.IndexOf("\r\n"));
                                        redirectUrl = "http://" + this.domain + redirectUrl;
                                        htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true);
                                    }
                                }
                            }
                            else
                            {
                                redirectUrl = "http://" + this.domain + redirectUrl;
                                this.n = redirectUrl.Substring(redirectUrl.IndexOf("n=") + "n=".Length);
                                htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true);
                            }
                            IsLoggedIn = true;
                        }
                        else if (htmlResponse.IndexOf("window.location = \"") != -1)
                        {
                            redirectUrl = htmlResponse.Substring(htmlResponse.IndexOf("window.location = \"") + "window.location = \"".Length);
                            redirectUrl = redirectUrl.Substring(0, redirectUrl.IndexOf("\";"));
                            this.n = redirectUrl.Substring(redirectUrl.IndexOf("n=") + "n=".Length);
                            if (htmlResponse.IndexOf("mt") != -1)
                            {
                                this.mt = htmlResponse.Substring(htmlResponse.IndexOf("mt=") + "mt=".Length);
                                this.mt = this.mt.Substring(0, this.mt.IndexOf(";"));
                            }
                            redirectUrl = "http://" + this.domain + redirectUrl;
                            htmlResponse = httpUtils.GetHttpResponse(redirectUrl, false);
                            IsLoggedIn = true;
                        }
                        else
                        {
                            IsLoggedIn = false;
                        }
                    }
                    else
                    {
                        IsLoggedIn = false;
                    }
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

        public override Boolean ImportContacts()
        {
            Contacts = new List<Contact>();
            String tmpName = "";
            String tmpEmail = "";
            String tmpPhone = "";
            Int32 count = 0, counter;
            String frm = "";
            String strHidden = "";
            String exportUrl = "http://" + this.domain + "/mail/options.aspx?subsection=26&n=" + this.n;
            String export = "";
            String redirectUrl = "";
            try
            {
                htmlResponse = httpUtils.GetHttpResponse(exportUrl, true);
                if (htmlResponse.IndexOf("Location:") != -1)
                {
                    redirectUrl = htmlResponse.Substring(htmlResponse.IndexOf("Location: ") + "Location: ".Length);
                    redirectUrl = redirectUrl.Substring(0, redirectUrl.IndexOf("\r\n"));
                    htmlResponse = httpUtils.GetHttpResponse(redirectUrl, true, "", "", false);
                }
                if (htmlResponse.IndexOf("<form name=\"Form1\"") != -1)
                {
                    frm = htmlResponse.Substring(htmlResponse.IndexOf("<form name=\"Form1\""));
                    frm = frm.Substring(0, frm.IndexOf("</form>"));
                    export = frm.Substring(frm.IndexOf("action=\"") + "action=\"".Length);
                    export = export.Substring(0, export.IndexOf("\""));
                    export = export.Replace("&amp;", "&");
                    export = "http://" + this.domain + "/mail/" + export;
                    strHidden = StringUtils.HiddenFields(frm);
                    strHidden = strHidden.Replace("&mt=", "");
                    postString = strHidden + "&ctl02%24ExportButton=Export+contacts&mt=" + this.mt;
                    htmlResponse = httpUtils.GetHttpResponse(export, false, postString, exportUrl, false);
                    if (htmlResponse.IndexOf("<title>Object moved</title>") != -1)
                    {
                        export = htmlResponse.Substring(htmlResponse.IndexOf("<a href=\"") + "<a href=\"".Length);
                        export = export.Substring(0, export.IndexOf("\""));
                        export = "http://" + this.domain + export;
                        htmlResponse = httpUtils.GetHttpResponse(export, false, "", exportUrl);
                    }


                    System.IO.MemoryStream strm = new System.IO.MemoryStream(System.Text.Encoding.UTF8.GetBytes(htmlResponse));
                    System.IO.StreamReader str = new System.IO.StreamReader(strm);
                    CSVReader csv = new CSVReader(str);
                    String[] fields;
                    String[] temp_line;

                    while ((fields = csv.GetCSVLine()) != null)
                    {
                        //					if(fields.Length < 5)
                        //						continue;
                        temp_line = new String[100];
                        if (fields.Length < 81)
                        {
                            fields = StringUtils.Split(fields[0].ToString(), ";");
                        }
                        if (count != 0)
                        {
                            counter = 0;
                            foreach (String field in fields)
                            {
                                temp_line[counter] = field;
                                counter++;
                            }
                            tmpName = (temp_line[1] != "" || temp_line[2] != "" || temp_line[3] != "") ? temp_line[1] + " " + temp_line[2] + " " + temp_line[3] : (((temp_line[78] != "") ? temp_line[78] : ((temp_line[79] != "") ? temp_line[79] : "")));
                            tmpEmail = (temp_line[46] != "") ? temp_line[46] : (((temp_line[49] != "") ? temp_line[49] : ((temp_line[52] != "") ? temp_line[52] : "")));
                            tmpPhone = temp_line[25];

                            if (tmpEmail != null)
                            {
                                tmpName = tmpName.Replace("\"", " ").Trim();
                                tmpEmail = tmpEmail.Replace("\"", " ").Trim();
                                tmpPhone = tmpPhone.Replace("\"", " ").Trim();

                                if (StringUtils.IsValidEmail(tmpEmail) && tmpName == "")
                                {
                                    tmpName = tmpEmail.Substring(0, tmpEmail.IndexOf("@"));
                                }

                                if (StringUtils.IsValidEmail(tmpEmail))
                                {
                                    Contacts.Add(
                                        new Contact
                                        {
                                            Name = tmpName,
                                            Email = tmpEmail,
                                            Phone = tmpPhone,
                                            Source = "Hotmail"
                                        });                                    
                                }
                            }
                        }
                        count++;
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
