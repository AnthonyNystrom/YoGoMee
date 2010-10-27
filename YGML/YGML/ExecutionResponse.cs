using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using yoGomee.Data;

namespace yoGomee.Interpreter
{
    public class ExecutionResponse
    {
        public int ErrorLineNumber { get; set; }
        public string DebugText { get; set; }
        public YogoAction YogoAction { get; set; }


    }
}
