using System;
using System.IO;
using System.Net;
using System.Drawing;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace yoGomee.Data
{
    public class YogoAction
    {
        public GomeeType ActionType { get; set; }
        public string TextToDisplay { get; set; }
        public string ImageUrl { get; set; }
        public string UrlToNavigateTo { get; set; }

        public override string ToString()
        {
            string ret = "Action: " + this.ActionType.ToString() + Environment.NewLine;
            ret += this.TextToDisplay;
            ret += this.TextToDisplay;
            ret += this.UrlToNavigateTo;

            return ret;
        }
    }
}
