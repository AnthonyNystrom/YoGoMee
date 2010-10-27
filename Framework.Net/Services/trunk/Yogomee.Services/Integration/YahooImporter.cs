using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;

namespace Yogomee.Services.Integration
{
    public class YahooImporter : ContactImporter
    {
        private HttpUtils httpUtils = null;
        private const String _addressBookUrl = "http://address.yahoo.com/yab/us/Yahoo_ab.csv?loc=us&.rand=1671497644&A=H&Yahoo_ab.csv";
        private const String _authUrl = "https://login.yahoo.com/config/login?";
        private const String _loginPage = "https://login.yahoo.com/config/login";
        private const String _userAgent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.3) Gecko/20070309 Firefox/2.0.0.3";

        public YahooImporter()
        {
            httpUtils = new HttpUtils();
        }

        public YahooImporter(String userId, String password)
            : base(userId, password)
        {
            httpUtils = new HttpUtils();
        }

        public override Boolean RequiresManualLogin
        {
            get { return false; }
        }

        //No login required
        public override Boolean DoLogin()
        {
            return true;
        }

        public override Boolean ImportContacts()
        {
            Contacts = new List<Contact>();
            Boolean result = false;

            try
            {
                WebClient webClient = new WebClient();
                webClient.Headers[HttpRequestHeader.UserAgent] = _userAgent;
                webClient.Encoding = Encoding.UTF8;

                Byte[] firstResponse = webClient.DownloadData(_loginPage);
                String firstRes = Encoding.UTF8.GetString(firstResponse);


                NameValueCollection postToLogin = new NameValueCollection();
                Regex regex = new Regex("type=\"hidden\" name=\"(.*?)\" value=\"(.*?)\"", RegexOptions.IgnoreCase);
                Match match = regex.Match(firstRes);
                while (match.Success)
                {
                    if (match.Groups[0].Value.Length > 0)
                    {
                        postToLogin.Add(match.Groups[1].Value, match.Groups[2].Value);
                    }
                    match = regex.Match(firstRes, match.Index + match.Length);
                }

                postToLogin.Add(".save", "Sign In");
                postToLogin.Add(".persistent", "y");

                String login = UserId.Split('@')[0];
                postToLogin.Add("login", login);
                postToLogin.Add("passwd", Password);

                webClient.Headers[HttpRequestHeader.UserAgent] = _userAgent;
                webClient.Headers[HttpRequestHeader.Referer] = _loginPage;
                webClient.Encoding = Encoding.UTF8;
                webClient.Headers[HttpRequestHeader.Cookie] = webClient.ResponseHeaders[HttpResponseHeader.SetCookie];

                webClient.UploadValues(_authUrl, postToLogin);
                String cookie = webClient.ResponseHeaders[HttpResponseHeader.SetCookie];

                if (String.IsNullOrEmpty(cookie))
                {
                    return false;
                }

                String newCookie = String.Empty;
                String[] tmp1 = cookie.Split(',');
                foreach (String var in tmp1)
                {
                    String[] tmp2 = var.Split(';');
                    newCookie = String.IsNullOrEmpty(newCookie) ? tmp2[0] : newCookie + ";" + tmp2[0];
                }

                // set login cookie
                webClient.Headers[HttpRequestHeader.Cookie] = newCookie;
                Byte[] thirdResponse = webClient.DownloadData(_addressBookUrl);
                String thirdRes = Encoding.UTF8.GetString(thirdResponse);

                String crumb = String.Empty;
                Regex regexCrumb = new Regex("type=\"hidden\" name=\"\\.crumb\" id=\"crumb1\" value=\"(.*?)\"", RegexOptions.IgnoreCase);
                match = regexCrumb.Match(thirdRes);
                if (match.Success && match.Groups[0].Value.Length > 0)
                {
                    crumb = match.Groups[1].Value;
                }


                NameValueCollection postDataAB = new NameValueCollection();
                postDataAB.Add(".crumb", crumb);
                postDataAB.Add("vcp", "import_export");
                postDataAB.Add("submit[action_export_yahoo]", "Export Now");

                webClient.Headers[HttpRequestHeader.UserAgent] = _userAgent;
                webClient.Headers[HttpRequestHeader.Referer] = _addressBookUrl;

                Byte[] FourResponse = webClient.UploadValues(_addressBookUrl, postDataAB);
                String csvData = Encoding.UTF8.GetString(FourResponse);

                String[] lines = csvData.Split('\n');
                foreach (String line in lines)
                {
                    String[] items = line.Split(',');
                    if (items.Length < 5)
                    {
                        continue;
                    }
                    String email = items[4];
                    String name = items[3];
                    if (!String.IsNullOrEmpty(email) && !String.IsNullOrEmpty(name))
                    {
                        email = email.Trim('\"');
                        name = name.Trim('\"');
                        if (!email.Equals("Email") && !name.Equals("Nickname"))
                        {
                            Contacts.Add(new Contact { Name = name, Email = email, Source = "Yahoo" });                          
                        }
                    }
                }

                result = true;
            }
            catch
            {
            }
            return result;
        }
    }
}
