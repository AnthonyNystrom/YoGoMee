using System;
using System.Web;
using System.IO;
using System.Net;
using System.Xml;
using System.Text;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace yoGomee.Interpreter
{
    public partial class AppInstance
    {
        public LocationEventArgs LocationEventArgs = null;
        public string[] SystemVariables = new string[] { "Longitude", "Latitude" };
        public List<Variable> ApplicationVariables = new List<Variable>();
        public string DebugOutput = string.Empty;
        

        public object this[string Name]
        {
            get
            {
                var Variable = from g in ApplicationVariables where g.Name == Name select g;

                if (Variable.Count() == 0)
                {
                    throw new Exception("No variable name '" + Name + "'");
                }
                else
                {
                    return Variable.First().Value;
                }
            }
            set
            {
                var VariableList = from g in ApplicationVariables where g.Name == Name select g;

                if (VariableList.Count() == 0)
                {
                    throw new Exception("No variable name '" + Name + "'");
                }
                else
                {
                    //ApplicationVariables.Remove((Variable)VariableList.First());
                    var Variable =  (Variable)VariableList.First();
                    Variable.Value = value;
                    //ApplicationVariables.Add(Variable);
                }
            }
        }

        public bool VariableExists(string Name)
        {
            var Variable = from g in ApplicationVariables where g.Name == Name select g;

            if (Variable.Count() == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }


        public void TriggerText(string Message)
        {
            Message = RenderString(Message);
            //MessageBox.Show(Message);
            DebugOutput += "Action:Text " + Message + Environment.NewLine;
        }

        //public static string GetSystemVariableValue(string FieldName)
        //{
        //    var Variable =
        //    from sv in SystemVariables
        //    where sv == FieldName
        //    select sv;

        //    string VariableValue = null;

        //    if (Variable.Count()==1)
        //    {
        //        if (FieldName=="Longitude")
        //        {
        //            VariableValue = LocationEventArgs.Location.Longitude.ToString();
        //        }
        //        else if(FieldName=="Latitude")
        //        {
        //            VariableValue = LocationEventArgs.Location.Longitude.ToString();
        //        }
        //    }

        //    return VariableValue;
        //}

        public object GetWebPost(string URL, string type,string username, string password,string Data)
        {
            var data = String.Format("status={0}", HttpUtility.UrlEncode(Data));
            var request = WebRequest.Create(URL);
            
            request.Credentials = new NetworkCredential(username, password);
            request.ContentType = "application/x-www-form-urlencoded";
            request.Method = "POST";

            var bytes = Encoding.UTF8.GetBytes(data);
            request.ContentLength = bytes.Length;
            var requestStream = request.GetRequestStream();
            requestStream.Write(bytes, 0, bytes.Length);
            var response = request.GetResponse();
            var stream = response.GetResponseStream();
            StreamReader reader = new StreamReader(stream);


            if (type == "text")
            {
                String ResponseString = reader.ReadToEnd();

                return ResponseString;
            }
            else if (type == "xml")
            {
                XmlDocument xmldoc = new XmlDocument();

                try
                {
                    xmldoc.Load(stream);
                    return xmldoc;
                }
                catch(Exception ex)
                {
                    DebugOutput += "Invalid XMLDocument Structure returned from POST"+Environment.NewLine;
                    return null;
                }
            }

            return null;
        }

        //public static string GetString(string FieldName)
        //{
            
        //    object ReturnObject = this(FieldName);

        //    string ReturnValue = (ReturnObject == null) ? "" : ReturnObject.ToString();

        //    return ReturnValue;
        //}

        public bool GetBoolean(string FieldName)
        {
            object ReturnObject = this[FieldName];

            bool ReturnValue = Convert.ToBoolean(ReturnObject);

            return ReturnValue;
        }

        public XmlNode GetXmlNodeByName(XmlDocument XmlDoc, string XmlNodeName)
        {
            XmlNodeList ReturnNode = XmlDoc.GetElementsByTagName(XmlNodeName);

            if (ReturnNode.Count > 0)
            {
                return ReturnNode[0];
            }

            return null;
        }

        public string GetXmlNodeInnerText(XmlNode XmlNode)
        {
            string InnerText = XmlNode.InnerText;

            return InnerText;
        }

        public string RenderString(string RenderString)
        {
            for (int i = 0; i < ApplicationVariables.Count; i++)
            {
                string MatchString = "{" + ApplicationVariables[i].Name + "}";

                var Value = ApplicationVariables[i].Value;

                if (Value != null)
                    RenderString = RenderString.Replace(MatchString, ApplicationVariables[i].Value.ToString());
            }

            return RenderString;
        }

        public string RenderStringForExpression(string RenderString)
        {
            for (int i = 0; i < ApplicationVariables.Count; i++)
            {
                string MatchString = "{" + ApplicationVariables[i].Name + "}";

                var Value = ApplicationVariables[i].Value;

                if (Value != null)
                {
                    string ReplaceWith = string.Empty;

                    if (ApplicationVariables[i].Value.GetType() == typeof(string))
                    {
                        ReplaceWith = "\"" + ApplicationVariables[i].Value.ToString() + "\"";
                        RenderString = @RenderString.Replace(MatchString, @ReplaceWith);
                    }
                    else
                    {
                        ReplaceWith = ApplicationVariables[i].Value.ToString();
                        RenderString = @RenderString.Replace(MatchString, @ReplaceWith);
                    }
                    
                    

                        
                }
            }

            return RenderString;
        }
    }

    [Serializable()]
    public class MobileTriggerEvent 
    {
        
    }

    [Serializable()]
    public class LocationEventArgs
    {
       public Location Location { get; set; }
       public DateTime DateTime { get; set; }
    }

    [Serializable()]
    public class Location
    {
        public string LocationName { get; set; }
        public double Longitude { get; set; }
        public double Latitute { get; set; }
    }

    [Serializable()]
    public class SaveState
    {
        public List<Variable> FieldVariables { get; set; }
        public List<Variable> Parameters { get; set; }

        public SaveState()
        {

        }
    }

}