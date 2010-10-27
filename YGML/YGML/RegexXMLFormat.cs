using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace yoGomee.Interpreter
{
    public class RegexXMLFormat
    {
        static String text = "<set FirstName=\"Alex\"/>";
        static String text2 = "<set Age=10/>";
        static String text3 = "<if x lt y >";
        static String text4 = String.Format("<if{0}x{1}lt{2}y >", Environment.NewLine, Environment.NewLine, Environment.NewLine);

        static String text5 = "<set FirstName=\"Alex\"/>"
            + Environment.NewLine
            + "<set Age=10/>"
            + Environment.NewLine
            + "<someothertag/>"
            + Environment.NewLine
            + "<if x lt y >";

        static String text6 = "<set x = 1+ 8 +1+ 35 + Int32.Parse\"99\" /    >";

        static String replacePattern = "<set name=\"{0}\" value=\"{1}\"/>";
        static String replacePattern2 = "<if value1=\"{0}\" value2=\"{1}\" operator=\"{2}\">";

        static Regex regex = new Regex("<set\\s+(?<param>\\w+)\\s*=\\s*(\\\"?)(?<value>.+?)\\1\\s*/>", RegexOptions.Singleline);
        static Regex regex2 = new Regex("<if\\s+(?<value1>\\w+)\\s+(?<op>\\w+)\\s+(?<value2>\\w+)\\s*>", RegexOptions.Singleline);
        static Regex regex3 = new Regex("<\\s*set\\s+x\\s*=\\s*(?<value>.+?)\\s*/\\s*>", RegexOptions.Singleline);

        static String replacePattern3 = "<set name=\"${param}\" value=\"${value}\"/>";
        static String replacePattern4 = "<if value1=\"${value1}\" value2=\"${op}\" operator=\"${value2}\">";


        public static String Modify(String inputString)
        {
            return regex2.Replace(regex.Replace(inputString, replacePattern3), replacePattern4);
        }
    }
}

