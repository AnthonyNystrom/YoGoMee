using System;
using System.IO;
using System.Xml;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using yoGomee.Data;
using System.Reflection;

namespace yoGomee.Interpreter
{
    public class RunWidget
    {
        public static List<Variable> GetInputParameters(InstalledWidget InstalledWidget)
        {
            List<Variable> UIProperties = new List<Variable>();

            StreamReader reader = File.OpenText(InstalledWidget.WidgetXMLPath);

            string Code = reader.ReadToEnd();

            Interpreter App = new Interpreter();
            DateTime Start = DateTime.Now;

            XmlDocument ApplicationXML = new XmlDocument();

            Code = RegexXMLFormat.Modify(Code);

            Code = "<widget>" + Code + "</widget>";

            try
            {
                ApplicationXML.LoadXml(Code);
                UIProperties = App.GetInputParameters(Code, InstalledWidget);
            }
            catch (XmlException ex)
            {
                throw ex;
            }

            return UIProperties;
        }

        public static void SaveInputParameters(InstalledWidget InstalledWidget, object[] InputParameters)
        {
            StreamReader reader = File.OpenText(InstalledWidget.WidgetXMLPath);
            string Code = reader.ReadToEnd();

            Interpreter App = new Interpreter();

            XmlDocument ApplicationXML = new XmlDocument();

            Code = RegexXMLFormat.Modify(Code);

            Code = "<widget>" + Code + "</widget>";

            try
            {
                ApplicationXML.LoadXml(Code);
                App.SaveInputParameters(Code, InputParameters, InstalledWidget);
            }
            catch (XmlException ex)
            {
                throw ex;
            }

        } 

        public static ExecutionResponse DebugWidget(string Code, string Path, string ApplicationName)
        {
            Interpreter App = new Interpreter(Path, ApplicationName);
            DateTime Start = DateTime.Now;

            XmlDocument ApplicationXML = new XmlDocument();
            ExecutionResponse response = new ExecutionResponse();


            Code = "<widget>" + Code + "</widget>";
            bool SyntaxOK = false;

            try
            {
                ApplicationXML.LoadXml(Code);
                SyntaxOK = true;
            }
            catch (XmlException ex)
            {
                App.Instance.DebugOutput += "XML syntax Error Line:" + ex.LinePosition + "  Position:" + ex.LinePosition;
                App.ExecutingLineNumber = ex.LinePosition;
            }

            if (SyntaxOK)
            {
                try
                {
                    App.Run(Code);
                    response.YogoAction = App.YogoAction;

                    App.Instance.DebugOutput += "Successful ";
                    App.ExecutingLineNumber = -1;
                }
                catch (Exception ex)
                {
                    App.Instance.DebugOutput += "Error on Line " + App.ExecutingLineNumber.ToString() + " : " + ex.Message.ToString() + Environment.NewLine;
                }

                TimeSpan ts = DateTime.Now - Start;

                App.Instance.DebugOutput += "Finished in " + ts.Minutes + ":" + ts.Seconds + ":" + ts.Milliseconds;

            }
            
            response.ErrorLineNumber = App.ExecutingLineNumber;
            response.DebugText = App.Instance.DebugOutput;

            return response;
        } 
    }
}
