using System;
using System.IO;
using System.Web;
using System.Net;
using System.Text;
using System.Drawing;
using System.Collections;
using System.Text.RegularExpressions;

namespace YGMEUserContactAccessAPI
{
    public class StringUtils
    {
        public StringUtils()
        {

        }
        public static String ParseValueBetween(String text, String prefix, String posix, bool includePrefix, bool includePosix)
        {
            String result = "";
            int prefixPos = -1, posixPos = -1;
            try
            {
                prefixPos = text.IndexOf(prefix);
                if (prefixPos >= 0)
                {
                    posixPos = text.IndexOf(posix, prefixPos + prefix.Length);
                    if (posixPos >= 0)
                    {
                        result = text.Substring(prefixPos + prefix.Length, posixPos - prefixPos - prefix.Length);
                        if (includePrefix)
                        {
                            result = prefix + result;
                        }
                        if (includePosix)
                        {
                            result = result + posix;
                        }
                    }

                }
            }
            catch (Exception)
            {
                // Console.WriteLine("Exception occurred : " + e);  
                result = "";
            }
            return result;
        }

        public static String ParseValueBetween(String text, String prefix, String posix)
        {
            return ParseValueBetween(text, prefix, posix, false, false);
        }

        public static string HiddenFields(String str)
        {
            str = str.Replace(">", ">\n");
            string pattern = @"<input.*hidden.*?>";
            MatchCollection mc = Regex.Matches(str, pattern);
            string text = "", t_text = "", name = "", val = "";
            string nmstr = "name=\"", vlstr = "value=\"";
            foreach (Match m in mc)
            {
                t_text = m.ToString();
                if (t_text.IndexOf(nmstr) != -1)
                {
                    name = t_text.Substring(t_text.IndexOf(nmstr) + nmstr.Length);
                    name = name.Substring(0, name.IndexOf("\""));
                }
                else if (t_text.IndexOf("name=") != -1)
                {
                    name = t_text.Substring(t_text.IndexOf("name=") + "name=".Length);
                    name = name.Substring(0, name.IndexOf(" "));
                }
                else
                {
                    name = t_text.Substring(t_text.IndexOf("name='") + "name='".Length);
                    name = name.Substring(0, name.IndexOf("'"));
                }
                if (t_text.IndexOf("value=\"") != -1)
                {
                    val = t_text.Substring(t_text.IndexOf(vlstr) + vlstr.Length);
                    val = val.Substring(0, val.IndexOf("\""));
                }
                else if (t_text.IndexOf("value='") != -1)
                {
                    val = t_text.Substring(t_text.IndexOf("value='") + "value='".Length);
                    val = val.Substring(0, val.IndexOf("'"));
                }
                else
                {
                    val = t_text.Substring(t_text.IndexOf("value=") + "value=".Length);
                    val = val.Substring(0, val.IndexOf(">"));
                    val = val.Replace("/", "").Trim();
                }
                if (text != "")
                    text += "&" + name + "=" + HttpUtility.UrlEncode(val);
                else
                    text += name + "=" + HttpUtility.UrlEncode(val);
            }

            pattern = @"<INPUT.*hidden.*?>";
            mc = Regex.Matches(str, pattern);
            foreach (Match m in mc)
            {
                t_text = m.ToString();
                name = t_text.Substring(t_text.IndexOf(nmstr) + nmstr.Length);
                name = name.Substring(0, name.IndexOf("\""));
                if (t_text.IndexOf(vlstr) == -1)
                {
                    val = "";
                }
                else
                {
                    val = t_text.Substring(t_text.IndexOf(vlstr) + vlstr.Length);
                    val = val.Substring(0, val.IndexOf("\""));
                }
                if (text != "")
                    text += "&" + name + "=" + HttpUtility.UrlEncode(val);
                else
                    text += name + "=" + HttpUtility.UrlEncode(val);
            }

            return text;
        }
        public static String[] ParseAllValueBetween(String text, String prefix, String posix, bool includePrefix, bool includePosix)
        {
            ArrayList list = new ArrayList();
            int startPos = text.IndexOf(prefix);
            int endPos = 1;
            while (startPos > 0 && startPos < text.Length)
            {
                startPos += prefix.Length;
                endPos = text.IndexOf(posix, startPos);
                if (endPos < startPos)
                    break;
                String parsedValue = text.Substring(startPos, endPos - startPos);
                if (includePrefix)
                {
                    parsedValue = prefix + parsedValue;
                }
                if (includePosix)
                {
                    parsedValue = parsedValue + posix;
                }
                list.Add(parsedValue);
                startPos = text.IndexOf(prefix, endPos + 1);
            }
            return (String[])(list.ToArray(typeof(String)));
        }

        public static String[] ParseAllValueBetween(String text, String prefix, String posix)
        {
            return ParseAllValueBetween(text, prefix, posix, false, false);
        }

        public static bool IsValidEmail(String email)
        {
            Regex exp = new Regex("^[^@ ]+@[^@ ]+\\.[^@ \\.]+$");
            return exp.IsMatch(email);
        }

        public static string StripTags(string strText)
        {
            char[] str = strText.ToCharArray();
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            int startPos = 0;
            int i = 0;
            try
            {
                for (i = 0; i < strText.Length; i++)
                {
                    if (str[i] == '<')
                    {
                        startPos = i;
                        i++;
                        while (str[i] != '>') i++;
                    }
                    else
                        sb.Append(str[i]);
                }
            }
            catch (Exception)
            {
                if (i == strText.Length)
                    sb.Append(strText.Substring(startPos));
            }
            return sb.ToString();
        }
        public static string[] Split(string content, string token)
        {
            Regex r = new Regex(@token);

            //@"\s*" + token + "\s*");
            return r.Split(content);
        }
    }
}