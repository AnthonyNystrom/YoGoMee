using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace yoGomee
{
    public enum FunctionAccess {Private, Public }

    public class Function
    {
        public string Name { get; set; }
        public string ReturnVariableName { get; set; }
        public FunctionAccess Access { get; set; }
        public string YGMLCode { get; set; }

    }
}
