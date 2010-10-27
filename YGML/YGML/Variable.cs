using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace yoGomee.Interpreter
{
    public enum VariableType {Global=0,UIField=1,System=2,InputParameter=3 }

    [Serializable]
    public class Variable
    {
        public Type Type { get; set; }
        public bool Persist { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
        public double MinValue { get; set; }
        public double MaxValue { get; set; }
        public bool Required { get; set; }
        public object Value { get; set; }
        public VariableType VariableType { get; set; }

        public override string ToString()
        {
            string Value = "Name:" + Name + Environment.NewLine;
            Value += "Type:" + Type.ToString() + Environment.NewLine;
            Value += "Value:" + Value + Environment.NewLine;
            Value += "MinValue:" + MinValue.ToString() + Environment.NewLine;
            Value += "MinValue:" + MinValue.ToString() + Environment.NewLine;
            Value += "Required:" + Required.ToString() + Environment.NewLine;

            return Value;
        }

        public Variable()
        {

        }

        public static void SaveApplicationState(List<Variable> Variables)
        {
            string SavePath = Interpreter.CodeDirectory + @"\" + Interpreter.ApplicationName + ".YgmlState";

            try
            {
                Stream stream = File.Create(SavePath);
                BinaryFormatter bformatter = new BinaryFormatter();

                bformatter.Serialize(stream, Variables);
                stream.Close();
            }
            catch (Exception ex)
            {
                int s = 100;
            }
        }


        public static List<Variable> OpenApplicationState()
        {
            string LoadPath = Interpreter.CodeDirectory + @"\" + Interpreter.ApplicationName + ".YgmlState";

            Stream stream = null;
            List<Variable> persistedvariables = new List<Variable>();

            try
            {
                stream = File.Open(LoadPath, FileMode.Open);
                BinaryFormatter bformatter = new BinaryFormatter();

                

                persistedvariables = (List<Variable>)bformatter.Deserialize(stream);

            }
            catch (Exception ex)
            {
                int s = 100;

            }
            finally
            {
                try
                {
                    stream.Close();
                }
                catch { }
            }

            return persistedvariables;

        }
    }
}
