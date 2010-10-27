using System;
using System.IO;
using System.Reflection;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using yoGomee;

namespace yoGomee.Interpreter
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();

        }

        private void btnRunApp_Click(object sender, EventArgs e)
        {
            string BaseCode = txtYGML.Text;

            BaseCode = RegexXMLFormat.Modify(BaseCode);

           // txtYGML.Text = BaseCode;
            //return;

            //string SourceCode = "<yogomeeapplication>" + BaseCode + "</yogomeeapplication>";

            //ExecutionResponse response = RunWidget.ExecuteCode(SourceCode,"MyApplication");

            //txtDebug.Text = response.DebugText+Environment.NewLine;

            //if (response.YogoAction == null)
            //    txtDebug.Text += "No action";

        }

        private void btnFormat_Click(object sender, EventArgs e)
        {
            string IndentedXml = XMLHelper.IndentXMLString(txtYGML.Text);

            if (IndentedXml != string.Empty)
            {
                txtYGML.Text = IndentedXml;
            }
        }

    }
}
