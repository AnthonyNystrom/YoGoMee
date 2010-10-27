namespace yoGomee.Interpreter
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnCheckLoop = new System.Windows.Forms.Button();
            this.btnRunApp = new System.Windows.Forms.Button();
            this.btnFormat = new System.Windows.Forms.Button();
            this.splitter1 = new System.Windows.Forms.Splitter();
            this.txtYGML = new System.Windows.Forms.TextBox();
            this.txtDebug = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // btnCheckLoop
            // 
            this.btnCheckLoop.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnCheckLoop.Location = new System.Drawing.Point(115, 485);
            this.btnCheckLoop.Name = "btnCheckLoop";
            this.btnCheckLoop.Size = new System.Drawing.Size(100, 28);
            this.btnCheckLoop.TabIndex = 1;
            this.btnCheckLoop.Text = "Check syntax";
            this.btnCheckLoop.UseVisualStyleBackColor = true;
            // 
            // btnRunApp
            // 
            this.btnRunApp.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnRunApp.Location = new System.Drawing.Point(613, 485);
            this.btnRunApp.Name = "btnRunApp";
            this.btnRunApp.Size = new System.Drawing.Size(127, 28);
            this.btnRunApp.TabIndex = 10;
            this.btnRunApp.Text = "Run!";
            this.btnRunApp.UseVisualStyleBackColor = true;
            this.btnRunApp.Click += new System.EventHandler(this.btnRunApp_Click);
            // 
            // btnFormat
            // 
            this.btnFormat.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnFormat.Location = new System.Drawing.Point(9, 485);
            this.btnFormat.Name = "btnFormat";
            this.btnFormat.Size = new System.Drawing.Size(100, 28);
            this.btnFormat.TabIndex = 13;
            this.btnFormat.Text = "Format YGML";
            this.btnFormat.UseVisualStyleBackColor = true;
            this.btnFormat.Click += new System.EventHandler(this.btnFormat_Click);
            // 
            // splitter1
            // 
            this.splitter1.Location = new System.Drawing.Point(0, 0);
            this.splitter1.Name = "splitter1";
            this.splitter1.Size = new System.Drawing.Size(3, 525);
            this.splitter1.TabIndex = 14;
            this.splitter1.TabStop = false;
            // 
            // txtYGML
            // 
            this.txtYGML.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtYGML.Font = new System.Drawing.Font("Courier New", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtYGML.Location = new System.Drawing.Point(9, 7);
            this.txtYGML.Multiline = true;
            this.txtYGML.Name = "txtYGML";
            this.txtYGML.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtYGML.Size = new System.Drawing.Size(731, 309);
            this.txtYGML.TabIndex = 16;
            this.txtYGML.Text = "<declare name=\"lawrence\" value=\"hello world\" />\r\n<set x=10/>\r\n<set y=x />\r\n";
            // 
            // txtDebug
            // 
            this.txtDebug.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtDebug.Location = new System.Drawing.Point(13, 324);
            this.txtDebug.Multiline = true;
            this.txtDebug.Name = "txtDebug";
            this.txtDebug.Size = new System.Drawing.Size(726, 155);
            this.txtDebug.TabIndex = 17;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(752, 525);
            this.Controls.Add(this.txtDebug);
            this.Controls.Add(this.splitter1);
            this.Controls.Add(this.btnFormat);
            this.Controls.Add(this.btnRunApp);
            this.Controls.Add(this.btnCheckLoop);
            this.Controls.Add(this.txtYGML);
            this.Name = "Form1";
            this.Text = "YGML Interpreter";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnCheckLoop;
        private System.Windows.Forms.Button btnRunApp;
        private System.Windows.Forms.Button btnFormat;
        private System.Windows.Forms.Splitter splitter1;
        private System.Windows.Forms.TextBox txtYGML;
        private System.Windows.Forms.TextBox txtDebug;
    }
}

