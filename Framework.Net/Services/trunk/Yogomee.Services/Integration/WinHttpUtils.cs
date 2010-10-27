using System;
using System.Collections;
using WinHttp;

namespace Yogomee.Services.Integration
{
    public class WinHttpUtils : IDisposable
    {
        private const String agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; .NET CLR 1.1.4322; InfoPath.1)";
        private WinHttp.WinHttpRequestClass winhttp = null;
        public WinHttpUtils()
        {
            winhttp = new WinHttpRequestClass();
        }

        public String GetHttpResponse(String url, Boolean includeHeader)
        {
            return GetHttpResponse(url, includeHeader, "", "");
        }

        public String GetHttpResponse(String url, Boolean includeHeader, String postFields, String referer)
        {
            return GetHttpResponse(url, includeHeader, postFields, referer, true);
        }

        public String GetHttpResponse(String url, Boolean includeHeader, String postFields, String referer, Boolean redirect)
        {
            String result = null;
            String method = "";
            Object obj = null;
            String rheader = "";
            if (url == null)
                return null;
            if (!url.StartsWith("http"))
                url = "http://" + url;
            try
            {
                if (postFields != "" && postFields != null)
                {
                    method = "POST";
                    obj = (Object)postFields;
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

        public String GetHttpResponse(String url, Boolean includeHeader, String postFields, String referer, Hashtable htCon)
        {
            String result = null;
            String method = "";
            Object obj = null;
            String rheader = "";
            if (url == null)
                return null;
            if (!url.StartsWith("http"))
                url = "http://" + url;
            try
            {
                if (postFields != "" && postFields != null)
                {
                    method = "POST";
                    obj = (Object)postFields;
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
