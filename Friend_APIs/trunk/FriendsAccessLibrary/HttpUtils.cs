using System;
using System.IO;
using System.Web;
using System.Net;
using System.Text;
using System.Drawing;
using System.Collections;

namespace YGMEUserContactAccessAPI
{
    /// <summary>
    /// Summary description for httpUtils.
    /// </summary>
    public class HttpUtils
    {
        private const String agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; .NET CLR 1.1.4322)";
        public static Image img;

        public HttpUtils()
        {
            _MyCookies = new CookieContainer();
        }

        public HttpUtils(CookieContainer container)
        {
            if (container != null) _MyCookies = container;
            else _MyCookies = new CookieContainer();
        }
        public string GetHttpResponse(string url, bool includeHeader)
        {
            return GetHttpResponse(url, includeHeader, "", "");
        }

        private CookieContainer _MyCookies = null;
        private Image _Image = null;
        public CookieContainer MyCookies
        {
            get
            {
                return _MyCookies;
            }
            set
            {
                _MyCookies = value;
            }
        }

        public Image capImg
        {
            get
            {
                return _Image;
            }
            set
            {
                _Image = value;
            }
        }

        public string GetHttpResponse(string url, bool includeHeader, string postFields, string referer)
        {
            string result = null;

            if (url == null)
                return null;
            if (!url.StartsWith("http"))
                url = "http://" + url;

            try
            {
                HttpWebRequest wreq = (HttpWebRequest)WebRequest.Create(url);
                wreq.UserAgent = agent;
                if (referer != null && referer != "")
                    wreq.Referer = referer;

                wreq.CookieContainer = MyCookies;
                wreq.Timeout = 30000;	// 30 seconds timeout

                if (postFields != null && postFields != "")
                {
                    byte[] data = Encoding.ASCII.GetBytes(postFields);

                    wreq.Method = "POST";
                    wreq.ContentType = "application/x-www-form-urlencoded";
                    wreq.ContentLength = data.Length;
                    Stream requestStream = wreq.GetRequestStream();
                    requestStream.Write(data, 0, data.Length);
                    requestStream.Close();
                }

                HttpWebResponse response = (HttpWebResponse)wreq.GetResponse();
                MyCookies.Add(response.Cookies);
                Stream s = response.GetResponseStream();

                //getimage
                if (url.IndexOf("getimage") > 0)
                {
                    _Image = Image.FromStream(s);
                }

                using (StreamReader sr = new StreamReader(s))
                {
                    result = sr.ReadToEnd();
                    sr.Close();
                }

                if (includeHeader)
                    result = string.Format("{0}\n\n{1}", response.Headers, result);

                s.Close();	// redundant
                response.Close();
            }
            catch (Exception)
            {
            }

            return result;
        }

        public string GetHttpResponse(string url, bool includeHeader, string postFields, string referer, string ContentType)
        {
            string result = null;

            if (url == null)
                return null;
            if (!url.StartsWith("http"))
                url = "http://" + url;

            try
            {
                HttpWebRequest wreq = (HttpWebRequest)WebRequest.Create(url);
                wreq.UserAgent = agent;
                if (referer != null && referer != "")
                    wreq.Referer = referer;

                wreq.CookieContainer = MyCookies;
                wreq.Timeout = 30000;	// 30 seconds timeout

                if (postFields != null && postFields != "")
                {
                    byte[] data = Encoding.ASCII.GetBytes(postFields);
                    wreq.Method = "POST";
                    if (ContentType != null && ContentType != "")
                    {
                        wreq.ContentType = ContentType;
                    }
                    else
                    {
                        wreq.ContentType = "application/x-www-form-urlencoded";
                        wreq.ContentLength = data.Length;
                    }
                    Stream requestStream = wreq.GetRequestStream();
                    requestStream.Write(data, 0, data.Length);
                    requestStream.Close();
                }

                HttpWebResponse response = (HttpWebResponse)wreq.GetResponse();
                MyCookies.Add(response.Cookies);
                Stream s = response.GetResponseStream();
                using (StreamReader sr = new StreamReader(s))
                {
                    result = sr.ReadToEnd();
                    sr.Close();
                }

                if (includeHeader)
                    result = string.Format("{0}\n\n{1}", response.Headers, result);

                s.Close();	// redundant
                response.Close();
            }
            catch (Exception)
            {
            }

            return result;
        }
        public string GetHttpResponse(string url, bool includeHeader, string postFields, string referer, string ContentType, bool headerRedirect)
        {
            string result = null;

            if (url == null)
                return null;
            if (!url.StartsWith("http"))
                url = "http://" + url;

            try
            {
                HttpWebRequest wreq = (HttpWebRequest)WebRequest.Create(url);
                wreq.UserAgent = agent;
                if (referer != null && referer != "")
                    wreq.Referer = referer;

                wreq.CookieContainer = MyCookies;
                wreq.Timeout = 30000;	// 30 seconds timeout

                if (postFields != null && postFields != "")
                {
                    byte[] data = Encoding.ASCII.GetBytes(postFields);
                    wreq.Method = "POST";
                    if (ContentType != null && ContentType != "")
                    {
                        wreq.ContentType = ContentType;
                    }
                    else
                    {
                        wreq.ContentType = "application/x-www-form-urlencoded";
                        wreq.ContentLength = data.Length;
                    }
                    Stream requestStream = wreq.GetRequestStream();
                    requestStream.Write(data, 0, data.Length);
                    requestStream.Close();
                }
                if (headerRedirect)
                {
                    wreq.AllowAutoRedirect = false;
                }
                HttpWebResponse response = (HttpWebResponse)wreq.GetResponse();
                MyCookies.Add(response.Cookies);
                Stream s = response.GetResponseStream();
                using (StreamReader sr = new StreamReader(s))
                {
                    result = sr.ReadToEnd();
                    sr.Close();
                }

                if (includeHeader)
                    result = string.Format("{0}\n\n{1}", response.Headers, result);

                s.Close();	// redundant
                response.Close();
            }
            catch (Exception)
            {
            }

            return result;
        }

        public string GetHttpResponse(string url, bool includeHeader, string postFields, string referer, Hashtable htContentType)
        {
            string result = null;

            if (url == null)
                return null;
            if (!url.StartsWith("http"))
                url = "http://" + url;

            try
            {
                HttpWebRequest wreq = (HttpWebRequest)WebRequest.Create(url);
                wreq.UserAgent = agent;
                if (referer != null && referer != "")
                    wreq.Referer = referer;

                wreq.CookieContainer = MyCookies;
                wreq.Timeout = 30000;	// 30 seconds timeout

                if (postFields != null && postFields != "")
                {
                    byte[] data = Encoding.ASCII.GetBytes(postFields);
                    wreq.Method = "POST";
                    //					if(ContentType != null && ContentType != "")
                    //					{
                    //						wreq.ContentType = ContentType;
                    //						
                    //					}
                    if (htContentType.Count > 0)
                    {
                        foreach (DictionaryEntry dt in htContentType)
                        {
                            wreq.Headers.Add(dt.Key.ToString(), dt.Value.ToString());


                        }
                    }
                    else
                    {
                        wreq.ContentType = "application/x-www-form-urlencoded";
                        wreq.ContentLength = data.Length;
                    }
                    Stream requestStream = wreq.GetRequestStream();
                    requestStream.Write(data, 0, data.Length);
                    requestStream.Close();
                }

                HttpWebResponse response = (HttpWebResponse)wreq.GetResponse();
                MyCookies.Add(response.Cookies);
                Stream s = response.GetResponseStream();
                using (StreamReader sr = new StreamReader(s))
                {
                    result = sr.ReadToEnd();
                    sr.Close();
                }

                if (includeHeader)
                    result = string.Format("{0}\n\n{1}", response.Headers, result);

                s.Close();	// redundant
                response.Close();
            }
            catch (Exception)
            {
            }

            return result;
        }
    }
}