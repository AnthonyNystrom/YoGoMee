using System;
using System.Web;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using yoGomee.Data;
using Jyc.Expr;

namespace yoGomee.Interpreter
{
    public class Interpreter
    {
        static string CurrentIndent = "                        ";
        public int ExecutingLineNumber = 0;

        public AppInstance Instance;
        public YogoAction YogoAction { get; set; }
        public List<Function> Functions = new List<Function>();
        public static string CodeDirectory = string.Empty;
        public static string ApplicationName = string.Empty;
        public Widget Widget { get; set; }

        public Function GetFunction(string Name)
        {
            var functions = from f in Functions where f.Name == Name select f;

            if (functions.Count() > 0)
            {
                return functions.First();
            }

            return null;
        }

        public Interpreter(Widget widget)
        {
            this.Widget = widget;
        }

        public Interpreter(string codeDirectory, string applicationName)
        {
            Instance = new AppInstance();
            Interpreter.CodeDirectory = codeDirectory;
            Interpreter.ApplicationName = applicationName;
        }

        public Interpreter()
        {
            Instance = new AppInstance();
        }

        public string BuildFunctions(string xml)
        {
            XmlDocument XmlDoc = new XmlDocument();
            XmlDoc.LoadXml(xml);

            XmlNodeList NodeList = XmlDoc.GetElementsByTagName("function");


            // now remove them
            for (int i = 0; i < NodeList.Count; i++)
			{
                string FunctionName = "";
                string Return = null;
                string Access = "";

                for (int j = 0; j < NodeList[i].Attributes.Count; j++)
                {
                    string Name = NodeList[i].Attributes[j].Name;
                    string Value = NodeList[i].Attributes[j].Value;

                    if (Name == "name")
                    {
                        FunctionName = Value;
                    }
                    else if (Name == "return")
                    {
                        Return = Value;
                    }
                }

                Function Function = new Function();
                Function.YGMLCode = "<function>"+NodeList[i].InnerXml+"</function>";
                Function.Name = FunctionName;
                Function.ReturnVariableName = Return;
                Function.Access = FunctionAccess.Public;

                Functions.Add(Function);

                XmlDoc.FirstChild.RemoveChild(NodeList[i]);
			}

            return XmlDoc.OuterXml;
        }

        public static object Evaluate(string Expression)
        {
            #region setup

            Type type = typeof(string);

            Parser ep = new Parser();

            Jyc.Expr.Evaluator evaluater = new Jyc.Expr.Evaluator();

            ParameterVariableHolder pvh = new ParameterVariableHolder();

            pvh.Parameters["char"] = new Parameter(typeof(char));
            pvh.Parameters["sbyte"] = new Parameter(typeof(sbyte));
            pvh.Parameters["byte"] = new Parameter(typeof(byte));
            pvh.Parameters["short"] = new Parameter(typeof(short));
            pvh.Parameters["ushort"] = new Parameter(typeof(ushort));
            pvh.Parameters["int"] = new Parameter(typeof(int));
            pvh.Parameters["uint"] = new Parameter(typeof(uint));
            pvh.Parameters["long"] = new Parameter(typeof(string));
            pvh.Parameters["ulong"] = new Parameter(typeof(ulong));
            pvh.Parameters["float"] = new Parameter(typeof(float));
            pvh.Parameters["double"] = new Parameter(typeof(double));
            pvh.Parameters["decimal"] = new Parameter(typeof(decimal));
            pvh.Parameters["DateTime"] = new Parameter(typeof(DateTime));
            pvh.Parameters["Int32"] = new Parameter(typeof(Int32));

            pvh.Parameters["string"] = new Parameter(typeof(string));
            pvh.Parameters["Guid"] = new Parameter(typeof(Guid));
            pvh.Parameters["HttpUtility"] = new Parameter(typeof(HttpUtility));
            pvh.Parameters["Convert"] = new Parameter(typeof(Convert));
            pvh.Parameters["Math"] = new Parameter(typeof(Math));
            pvh.Parameters["Array "] = new Parameter(typeof(Array));
            pvh.Parameters["Random"] = new Parameter(typeof(Random));
            pvh.Parameters["TimeZone"] = new Parameter(typeof(TimeZone));
            pvh.Parameters["AppDomain "] = new Parameter(typeof(AppDomain));
            pvh.Parameters["Console"] = new Parameter(typeof(Console));
 

            evaluater.VariableHolder = pvh;
            #endregion

            Tree tree = ep.Parse(Expression);

            object result = evaluater.Eval(tree);

            

            return result;
        }

        public void Run(string xml)
        {
            //Instance.ApplicationVariables = Variable.OpenApplicationState();

            xml = BuildFunctions(xml);

            StartInterpretting(xml);

            //persist to storage
            //var persistvars = from v in Instance.ApplicationVariables where v.Persist == true select v;
            //Variable.SaveApplicationState(persistvars.ToList());
        }

        public List<Variable> GetInputParameters(string xml,InstalledWidget InstalledWidget)
        {
            Instance.ApplicationVariables = Variable.OpenApplicationState();

            GetInputParameterTags(xml);

            var IParamsInterator = from v in Instance.ApplicationVariables where v.VariableType == VariableType.InputParameter select v;

            List<Variable> IParams = (List<Variable>)IParamsInterator.ToList();

            XmlDocument XmlDoc = new XmlDocument();
            try
            {
                XmlDoc.Load(InstalledWidget.InputParameterXmlpath);

                XmlNodeList Nodes = XmlDoc.GetElementsByTagName("inputparameter");

                for (int i = 0; i < IParams.Count(); i++)
                {
                    string InputParameterName = IParams[i].Name;

                    for (int j = 0; j < Nodes.Count; j++)
                    {
                        string InputName = "";
                        string InputValue = "";

                        for (int k = 0; k < Nodes[i].Attributes.Count; k++)
                        {
                            string AttributeName = Nodes[i].Attributes[k].Name;

                            if (AttributeName == "name")
                            {
                                InputName = Nodes[i].Attributes[k].Value;

                                if (InputName == InputParameterName)
                                {
                                    IParams[i].Value = Nodes[i].InnerText;
                                    //IParams[i].Label = "";
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }

            

            return IParams.ToList();
        }

        /// <summary>
        /// Takes an array organised linearly mapped in order of the InputParameter tags
        /// </summary>
        /// <param name="xml"></param>
        public void SaveInputParameters(string xml,object[] InputParameters ,InstalledWidget InstalledWidget)
        {
            List<Variable> InputParameterTags = GetInputParameters(xml, InstalledWidget);


            string Xml = "";

            for (int i = 0; i < InputParameters.Length; i++)
			{
                Xml += String.Format(@"<inputparameter name=""{0}"">{1}</inputparameter>" + Environment.NewLine, InputParameterTags[i].Name, InputParameters[i]);
			}

            FileInfo f = new FileInfo(InstalledWidget.InputParameterXmlpath);
            StreamWriter writer = f.CreateText();

            writer.Write("<parameters>" + Xml + "</parameters>");
            writer.Flush();
            writer.Close();

        }

        public void SaveUIFields()
        {
            //persist to storage
            Variable.SaveApplicationState(Instance.ApplicationVariables);
        }

        public void GetInputParameterTags(string xml)
        {
            XmlTextReader reader = new XmlTextReader(new StringReader(xml));

            reader.Normalization = true;

            string Type = string.Empty;

            #region branch on Xml

            while (reader.Read())
            {

            Restart:



                ExecutingLineNumber = reader.LineNumber;

                switch (reader.NodeType)
                {

                    case XmlNodeType.Element:
                        Type = reader.Name.ToString();
                        if (Type == "inputparameter")
                        {
                            ExecuteInputParameter(reader, true);
                        }
                        break;
                    case XmlNodeType.Text:
                        break;
                    case XmlNodeType.EndElement:
                        break;
                }
            }

            #endregion
        }

        public void StartInterpretting(string xml)
        {
            XmlTextReader reader = new XmlTextReader(new StringReader(xml));

            reader.Normalization = true;

            string Type = string.Empty;

            #region branch on Xml

            bool DontSkip = true;
            bool IsTrue = true;
            bool IfJustEnded = false;

            while (reader.Read())
            {

                Restart:

                ExecutingLineNumber = reader.LineNumber;

                switch (reader.NodeType)
                {
                    
                    case XmlNodeType.Element:
                        Type = reader.Name.ToString();


                        if (Type == "if")
                        {
                            IsTrue = ExecuteIF(reader, true);

                            // if its false then skip to the end of the if
                            if (!IsTrue)
                            {
                                reader.Skip();
                              
                                goto Restart;
                            }
                        }
                        else if (Type == "set")
                        {
                            ExecuteSet(reader, true);
                        }
                        else if (Type == "declare")
                        {
                            ExecuteDeclare(reader, true);
                        }
                        else if (Type == "inputparameter")
                        {
                            ExecuteInputParameter(reader, true);
                        }
                        else if (Type == "action")
                        {
                            if (DontSkip)
                            ExecuteAction(reader, true);
                        }
                        else if (Type == "webpost")
                        {
                            if (DontSkip)
                            ExecuteWebPost(reader, true);
                        }
                        else if (Type == "xmlnode")
                        {
                            if (DontSkip)
                            ExecuteGetXMLNode(reader, true);
                        }
                        else if (Type == "xmlinnertext")
                        {
                            if (DontSkip)
                            ExecuteGetXMLText(reader, true);
                        }
                        else if (Type == "parameter")
                        {
                            if (DontSkip)
                            ExecuteParameter(reader, true);
                        }
                        else if (Type == "urlencode")
                        {
                            if (DontSkip)
                                ExecuteURLEncode(reader, true);
                        }
                        else if (Type == "function")
                        {
                            if (DontSkip)
                                ExecuteFunction(reader, true);
                        }
                        else if (Type == "call")
                        {
                            if (DontSkip)
                                ExecuteCall(reader, true);
                        }
                        else if (Type == "else")
                        {
                            //if (IfJustEnded)
                            //{
                                //if the 'if' statement was true then skip past the else
                                if (IsTrue)
                                {
                                    reader.Skip();
                                }
                            //}
                            //else
                            //{
                            //    throw new Exception("else statement badly positioned");
                            //}
                        }
                        else
                        {
                            reader.Value.ToString();
                        }

                        break;
                    case XmlNodeType.Text:
                     
                        break;
                    case XmlNodeType.EndElement:
                        Type = reader.Name.ToString();
                        if (Type == "if")
                        {
                            IfJustEnded = true;
                        }
                        else if (Type == "else")
                        {

                        }
                        else
                        {
                            reader.Value.ToString();
                        }

                        break;
                }
            }

            #endregion
        }

        public void ExecuteURLEncode(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string InputValue = "";
            string OutputVar = "";

            for (int i = 0; i < reader.AttributeCount; i++)
			{
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "value")
                {
                    InputValue = Instance.RenderString(Value);
                }
                else if (Name == "outputvar")
                {
                    OutputVar = Value;
                }
                
			}

            Instance[OutputVar] = HttpUtility.UrlEncode(InputValue);
        }

        public void ExecuteCall(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string FunctionName = "";
            string OutputVarName = "";

            for (int i = 0; i < reader.AttributeCount; i++)
			{
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "name")
                {
                    FunctionName = Value;
                }
                else if (Name == "outputvar")
                {
                    OutputVarName = Value;
                }               
			}

            Function function = GetFunction(FunctionName);

            StartInterpretting(function.YGMLCode);

        }

        public void ExecuteFunction(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string FunctionName = "";
            string Returns = "";
            string Access = "";

            for (int i = 0; i < reader.AttributeCount; i++)
			{
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "name")
                {
                    FunctionName = Instance.RenderString(Value);
                }
                else if (Name == "returns")
                {
                    Returns = Value;
                }
                else if (Name == "access")
                {
                    Access = Value;
                }
                
			}

            //reader.no

           
        }


        public void ExecuteWebPost(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string URL = "";
            string OutputVariable = "";
            string OutputFormat = "text";
            string UserName = string.Empty;
            string Password = string.Empty;
            string Data = string.Empty;

            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "url")
                {
                    URL = Instance.RenderString(Value);
                }
                else if (Name == "outputvar")
                {
                    OutputVariable = Value;
                }
                else if (Name == "outputformat")
                {
                    OutputFormat = Value;
                }
                else if (Name == "username")
                {
                    UserName = Instance.RenderString(Value);
                }
                else if (Name == "password")
                {
                    Password = Instance.RenderString(Value);
                }
                else if (Name == "data")
                {
                    Data = Instance.RenderString(Value);
                }
            }

            if (!Instance.VariableExists(OutputVariable))
            {
                var Variable = new Variable();
                Variable.VariableType = VariableType.Global;
                Variable.Name = OutputVariable;

                Instance.ApplicationVariables.Add(Variable);
            }

            Instance[OutputVariable] = Instance.GetWebPost(URL, OutputFormat, UserName, Password, Data);

        }

        public void ExecuteGetXMLText(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string XmlNodeVariable = "";
            string OutputVariable = "";

            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "xmlnode")
                {
                    XmlNodeVariable = Value;
                }
                else if (Name == "outputvar")
                {
                    OutputVariable = Value;
                }
            }

            var XmlNode = (XmlNode)Instance[XmlNodeVariable];

            if (!Instance.VariableExists(OutputVariable))
            {
                var Variable = new Variable();
                Variable.VariableType = VariableType.Global;
                Variable.Name = OutputVariable;

                Instance.ApplicationVariables.Add(Variable);
            }

            Instance[OutputVariable] = Instance.GetXmlNodeInnerText(XmlNode);
        }

        public void ExecuteGetXMLNode(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string XmlDocumentVariable = "";
            string NodeName = "";
            string OutputVariable = "";

            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "xmldocument")
                {
                    XmlDocumentVariable = Value;
                }
                else if (Name == "nodename")
                {
                    NodeName = Value;
                }
                else if (Name == "outputvar")
                {
                    OutputVariable = Value;
                }
            }

            XmlDocument XmlDoc = (XmlDocument)Instance[XmlDocumentVariable];

            XmlNodeList Xmlnodelist = XmlDoc.GetElementsByTagName("description");

            if (Xmlnodelist.Count==0)
            {
                throw new Exception("No Node with name '" + NodeName+"'");
            }
            else
            {
                if(!Instance.VariableExists(OutputVariable))
                {
                    var Variable  = new Variable();
                    Variable.VariableType = VariableType.Global;
                    Variable.Name = OutputVariable;

                    Instance.ApplicationVariables.Add(Variable);   
                }

                Instance[OutputVariable] = Xmlnodelist[0];
            }
        }

        public static string ExecuteXMLDoc(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string XmlDocument = "";

            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "value1")
                {
                    XmlDocument = Value;
                }
                else if (Name == "value1")
                {
                    XmlDocument = Value;
                }
            }

            return CurrentIndent + Statement;
        }

        public bool ExecuteIF(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string Value1 = "";
            string Value2 = "";
            string Operator = "";

            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "value1")
                {
                    Value1 = Value;
                }
                else if (Name == "operator")
                {
                    Value2 = Value;
                }
                else if (Name == "value2")
                {
                    Operator = Value;
                }
            }

            object CastedValue1 = null;

            if (Instance.VariableExists(Value1))
            {
                // first see if its a ref
                CastedValue1 = Instance[Value1];
            }
            else
            {
                try
                {
                    // then see if its a number
                    CastedValue1 = Double.Parse(Value1);
                }
                catch
                {
                    try
                    {
                        // then see if its a bool
                        CastedValue1 = bool.Parse(Value1);
                    }
                    catch
                    {
                        // haha it must be a string!
                        CastedValue1 = Value1;
                    }
                }
            }

            object CastedValue2 = null;

            if (Instance.VariableExists(Value2))
            {
                // first see if its a ref
                CastedValue2 = Instance[Value2];
            }
            else
            {
                try
                {
                    // then see if its a number
                    CastedValue2 = Double.Parse(Value2);
                }
                catch
                {
                    try
                    {
                        // then see if its a bool
                        CastedValue2 = bool.Parse(Value2);
                    }
                    catch
                    {
                        // haha it must be a string!
                        CastedValue2 = Value2;
                    }
                }
            }

            bool IsTrue = false;

            if (CastedValue1.GetType() == typeof(string))
            {
                if (Operator == "eq")
                {
                    IsTrue = (CastedValue1.ToString() == CastedValue2.ToString());
                }
                else
                {
                    throw new Exception(Operator + " is not a valider comparison operator for type string");
                }
            }

            if (CastedValue1.GetType() == typeof(bool))
            {
                if (Operator == "eq")
                {
                    IsTrue = (CastedValue1.ToString() == CastedValue2.ToString());
                }
                else
                {
                    throw new Exception(Operator + " is not a valider comparison operator for type bool");
                }
            }

            else if (CastedValue1.GetType()==typeof(double))
            {
                double dValue1 = (double)CastedValue1;
                double dValue2 = (double)CastedValue2;

                if (Operator == "eq")
                {
                    IsTrue = (dValue1 == dValue2);
                }
                else if (Operator == "lt")
                {
                    IsTrue = (dValue1 < dValue2);
                }
                else if (Operator == "lte")
                {
                    IsTrue = (dValue1 <= dValue2);
                }
                else if (Operator == "gt")
                {
                    IsTrue = (dValue1 > dValue2);
                }
                else if (Operator == "gte")
                {
                    IsTrue = (dValue1 >= dValue2);
                }
                else
                {
                    throw new Exception("no such comparison operator as "+Operator);
                }
            }

            return IsTrue;
        }

        public void ExecuteAction(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string Type = "";
            string Message = "";
            string ImageUrl = "";
            string NagivateUrl = "";


            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "type")
                {
                    Type = Value;
                }
                else if (Name == "message")
                {
                    Message = Instance.RenderString(Value);
                }
                else if (Name == "imageurl")
                {
                    ImageUrl = Instance.RenderString(Value);
                }
                else if (Name == "url")
                {
                    NagivateUrl = Instance.RenderString(Value);
                }
            }

            YogoAction action = new YogoAction();

            if (Type == "text")
            {
                action.ActionType = ActionType.Text;
                action.TextToDisplay = Message;
            }
            else if (Type == "image")
            {
                action.ActionType = ActionType.Image;
                action.ImageUrl = ImageUrl;
            }
            else if (Type == "browser")
            {
                action.ActionType = ActionType.Browser;
                action.UrlToNavigateTo = NagivateUrl;
            }

            this.YogoAction = action;

            Instance.TriggerText(Message);
        }

        public void ExecuteUIField(XmlTextReader reader, bool OpenElement)
        {
            string VariableName = "";
            string DefaultValue = "";
            string Required = "true";
            bool bRequired = true;
            string FieldType = "";

            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "name")
                {
                    VariableName = Value;
                }
                else if (Name == "value")
                {
                    DefaultValue = Value;
                }
                else if (Name == "required")
                {
                    bRequired = bool.Parse(Value);
                }
                else if (Name == "fieldtype")
                {
                    FieldType = Value;
                }
            }

            if (!Instance.VariableExists(VariableName))
            {
                Variable variable = new Variable();
                variable.Name = VariableName;
                variable.Required = bRequired;
                variable.Value = Instance.RenderString(DefaultValue);
                variable.VariableType = yoGomee.Interpreter.VariableType.UIField;
                Instance.ApplicationVariables.Add(variable);
            }


        }

        public void ExecuteInputParameter(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string VariableName = "";
            string VariableType = "";
            string VariableValue = "";
            string Persist = "false";
            bool bPersist = false;


            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "name")
                {
                    VariableName = Value;
                }
                else if (Name == "type")
                {
                    VariableType = Value;
                }
                else if (Name == "value")
                {
                    VariableValue = Value;
                }
                else if (Name == "persist")
                {
                    bPersist = bool.Parse(Value);
                }
            }

            Variable variable = new Variable();
            variable.Name = VariableName;
            //variable.Type = typeof(VariableValue);
            variable.Value = VariableValue;
            variable.Persist = bPersist;
            variable.VariableType = yoGomee.Interpreter.VariableType.InputParameter;

            Instance.ApplicationVariables.Add(variable);

        }

        public void ExecuteSet(XmlTextReader reader, bool OpenElement)
        {
            string VariableName = "";
            string VariableValue = "";

            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "name")
                {
                    VariableName = Value;
                }
                else if (Name == "value")
                {
                    VariableValue = Value;
                }
            }

            if (!Instance.VariableExists(VariableName))
            {
                Variable variable = new Variable();
                variable.Name = VariableName;
                variable.VariableType = yoGomee.Interpreter.VariableType.Global;
                Instance.ApplicationVariables.Add(variable);
            }

            object CastedValue = null;


            if (VariableValue != string.Empty)
            {
                if (Instance.VariableExists(VariableValue))
                {
                    // first see if its a ref
                    CastedValue = Instance[VariableValue];
                }
                else
                {
                    VariableValue = Instance.RenderStringForExpression(VariableValue);

                    // this is a bit of a temp hack
                    VariableValue = VariableValue.Replace(@"'", @"""");
                    VariableValue = Evaluate(VariableValue).ToString();

                    try
                    {
                        // then see if its a number
                        CastedValue = Double.Parse(VariableValue);
                    }
                    catch
                    {
                        try
                        {
                            // then see if its a bool
                            CastedValue = bool.Parse(VariableValue);
                        }
                        catch
                        {
                            // haha it must be a string!
                            CastedValue = VariableValue.ToString();
                        }

                    }
                }
            }

            Instance[VariableName] = CastedValue;
        }

        public void ExecuteParameter(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string ParamName = "";
            string Type = "";
            double MinValue = -1;
            double MaxValue = -1;
            object ParamValue = null;
            bool Required = false;

            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "name")
                {
                    ParamName = Value;
                }
                else if (Name == "type")
                {
                    Type = Value;
                }
                else if (Name == "defaultvalue")
                {
                    if (Type == "string")
                    {
                        ParamValue = Value;
                    }
                    else if(Type == "int")
                    {
                        ParamValue = Int32.Parse(Value);
                    }
                     else if(Type == "decimal")
                    {
                        ParamValue = double.Parse(Value);
                    }
                }
                else if (Name == "minvalue")
                {
                    MinValue = double.Parse(Value);
                }
                else if (Name == "maxvalue")
                {
                    MaxValue = double.Parse(Value);
                }
                else if (Name == "required")
                {
                    Required = bool.Parse(Value);
                }
            }

            var Variable  = new Variable();
            Variable.VariableType = VariableType.UIField;
            Variable.Name = ParamName;
            Variable.MinValue = MinValue;
            Variable.MaxValue = MaxValue;
            Variable.Required = Required;
            Variable.Value = ParamValue;

            Instance.ApplicationVariables.Add(Variable);            
        }

        public void ExecuteDeclare(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;
            string VariableName = "";
            string VariableType = "";
            string VariableValue = "";
            string Persist = "false";
            bool bPersist = false;


            for (int i = 0; i < reader.AttributeCount; i++)
            {
                reader.MoveToAttribute(i);

                string Name = reader.Name;
                string Value = reader.Value;

                if (Name == "name")
                {
                    VariableName = Value;
                }
                else if (Name == "type")
                {
                    VariableType = Value;
                }
                else if (Name == "value")
                {
                    VariableValue = Value;
                }
                else if (Name == "persist")
                {
                    bPersist = bool.Parse(Value);
                }
            }

            Variable variable = new Variable();
            variable.Name = VariableName;
            //variable.Type = typeof(VariableValue);
            variable.Value = VariableValue;
            variable.Persist = bPersist;
            variable.VariableType = yoGomee.Interpreter.VariableType.Global;

            Instance.ApplicationVariables.Add(variable);
            
        }

        public static string ExecuteElse(XmlTextReader reader, bool OpenElement)
        {
            string Statement = string.Empty;

            Statement = (OpenElement) ? "else\r\n" + CurrentIndent + "{\r\n" : "\r\n" + CurrentIndent + "}";

            return CurrentIndent + Statement;
        }

 
        public static bool CheckYGMLSyntax(string YGML)
        {
            bool bad = false;

            try
            {
                System.Xml.XmlDocument xmldoc = new System.Xml.XmlDocument();

                xmldoc.LoadXml(YGML);
            }
            catch (XmlException ex)
            {
                //MessageBox.Show("Error Line:" + ex.LinePosition + "  Position:" + ex.LinePosition);
                bad = true;
            }

            return bad;

        }
    }
}