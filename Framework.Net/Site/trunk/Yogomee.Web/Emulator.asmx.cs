using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using yoGomee.Data;
using yoGomee.Interpreter;

namespace yoGomee
{
    /// <summary>
    /// Summary description for Emulator
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class Emulator : System.Web.Services.WebService
    {

        [WebMethod]
        public ExecutionResponse RunApplication(string ApplicationName)
        {

            string SamplePath = Server.MapPath("./") + @"\CodeSamples\";

            

            StreamReader reader = File.OpenText(SamplePath + ApplicationName+".xml");

            string Code = reader.ReadToEnd();

            reader.Close();

            //var Response = Interpreter.RunApplication.ExecuteCode(Code);

            // just to test
            //YogoAction action = new YogoAction()
            //{
            //    //ActionType = ActionType.Text,
            //    //TextToDisplay = "Hellow world! Hellow world! Hellow world! Hellow world! Hellow world! Hellow world!"
            //    ActionType = ActionType.Image,
            //    ImageUrl = "http://www.wired.com/images/home/wired_logo.gif"
            //};

            //Response.YogoAction = action;

            return null;
        }

        [WebMethod]
        public string[] GetApplicationList()
        {
            string SamplePath = Server.MapPath("./") + @"\CodeSamples\";
            string[] SampleFiles = Directory.GetFiles(SamplePath);

            List<string> Names = new List<string>();

            for (int i = 0; i < SampleFiles.Length; i++)
            {
                FileInfo Label = new FileInfo(SampleFiles[i]);

                string Name = Label.Name.Substring(0,Label.Name.Length-4);

                Names.Add(Name);
            }

            return Names.ToArray();
        }
    }
}
