using System;
using WinHttp;
using System.Collections;

namespace YGMEUserContactAccessAPI
{
    /// <summary>
    /// Summary description for WinHttpUtils.
    /// </summary>
    public class WinHttpUtils : IDisposable
    {
        private const String agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; .NET CLR 1.1.4322; InfoPath.1)";
        private WinHttp.WinHttpRequestClass winhttp = null;
        public WinHttpUtils()
        {
            winhttp = new WinHttpRequestClass();
        }

        public string GetHttpResponse(string url, bool includeHeader)
        {
            return GetHttpResponse(url, includeHeader, "", "");
        }

        public string GetHttpResponse(string url, bool includeHeader, string postFields, string referer)
        {
            return GetHttpResponse(url, includeHeader, postFields, referer, true);
        }

        public string GetHttpResponse(string url, bool includeHeader, string postFields, string referer, bool redirect)
        {
            string result = null;
            string method = "";
            object obj = null;
            string rheader = "";
            if (url == null)
                return null;
            if (!url.StartsWith("http"))
                url = "http://" + url;
            try
            {
                if (postFields != "" && postFields != null)
                {
                    method = "POST";
                    obj = (object)postFields;
                }
                else
                {
                    method = "GET";
                }
                winhttp.Open(method, url, null);
                winhttp.SetRequestHeader("User-Agent", agent);
                if (referer != "" && referer != null)
                {
                    winhttp.SetRequestHeader("Referer", referer);
                }
                if (method.Equals("POST"))
                {
                    winhttp.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                }
                if (!redirect)
                    winhttp.set_Option(WinHttp.WinHttpRequestOption.WinHttpRequestOption_EnableRedirects, false);
                winhttp.Send(obj);
                if (includeHeader)
                {
                    rheader = winhttp.GetAllResponseHeaders();
                }

                result = rheader + winhttp.ResponseText;
                return result;


            }
            catch
            {
                return "";
            }

        }

        public string GetHttpResponse(string url, bool includeHeader, string postFields, string referer, Hashtable htCon)
        {
            string result = null;
            string method = "";
            object obj = null;
            string rheader = "";
            if (url == null)
                return null;
            if (!url.StartsWith("http"))
                url = "http://" + url;
            try
            {
                if (postFields != "" && postFields != null)
                {
                    method = "POST";
                    obj = (object)postFields;
                }
                else
                {
                    method = "GET";
                }
                winhttp.Open(method, url, null);
                winhttp.SetRequestHeader("User-Agent", agent);
                if (htCon.Count > 0)
                {
                    foreach (DictionaryEntry dt in htCon)
                    {
                        winhttp.SetRequestHeader(dt.Key.ToString(), dt.Value.ToString());
                    }
                }
                if (referer != "" && referer != null)
                {
                    winhttp.SetRequestHeader("Referer", referer);
                }
                if (method.Equals("POST"))
                {
                    winhttp.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                }

                winhttp.Send(obj);
                if (includeHeader)
                {
                    rheader = winhttp.GetAllResponseHeaders();
                }

                result = rheader + winhttp.ResponseText;
                return result;


            }
            catch
            {
                return "";
            }

        }

        public void Dispose()
        {
            winhttp = null;
        }


    }
}
