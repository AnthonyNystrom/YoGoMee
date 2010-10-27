namespace yoGomee.Emulator
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.pnlScreen = new System.Windows.Forms.Panel();
            this.axWebBrowser1 = new AxSHDocVw.AxWebBrowser();
            this.btnRun = new System.Windows.Forms.Button();
            this.lbApplications = new System.Windows.Forms.ListBox();
            this.txtDebug = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.pnlScreen.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.axWebBrowser1)).BeginInit();
            this.SuspendLayout();
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(5, 6);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(268, 502);
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            // 
            // pnlScreen
            // 
            this.pnlScreen.BackColor = System.Drawing.Color.White;
            this.pnlScreen.Controls.Add(this.axWebBrowser1);
            this.pnlScreen.Location = new System.Drawing.Point(53, 80);
            this.pnlScreen.Name = "pnlScreen";
            this.pnlScreen.Size = new System.Drawing.Size(173, 249);
            this.pnlScreen.TabIndex = 1;
            // 
            // axWebBrowser1
            // 
            this.axWebBrowser1.Enabled = true;
            this.axWebBrowser1.Location = new System.Drawing.Point(3, 3);
            this.axWebBrowser1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axWebBrowser1.OcxState")));
            this.axWebBrowser1.Size = new System.Drawing.Size(168, 243);
            this.axWebBrowser1.TabIndex = 0;
            // 
            // btnRun
            // 
            this.btnRun.Location = new System.Drawing.Point(279, 123);
            this.btnRun.Name = "btnRun";
            this.btnRun.Size = new System.Drawing.Size(268, 32);
            this.btnRun.TabIndex = 2;
            this.btnRun.Text = "Run";
            this.btnRun.UseVisualStyleBackColor = true;
            this.btnRun.Click += new System.EventHandler(this.txtRun_Click);
            // 
            // lbApplications
            // 
            this.lbApplications.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbApplications.FormattingEnabled = true;
            this.lbApplications.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.lbApplications.ItemHeight = 20;
            this.lbApplications.Location = new System.Drawing.Point(279, 12);
            this.lbApplications.Name = "lbApplications";
            this.lbApplications.Size = new System.Drawing.Size(268, 104);
            this.lbApplications.TabIndex = 3;
            this.lbApplications.DoubleClick += new System.EventHandler(this.lbApplications_DoubleClick);
            // 
            // txtDebug
            // 
            this.txtDebug.Location = new System.Drawing.Point(275, 161);
            this.txtDebug.Multiline = true;
            this.txtDebug.Name = "txtDebug";
            this.txtDebug.Size = new System.Drawing.Size(272, 337);
            this.txtDebug.TabIndex = 5;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(559, 510);
            this.Controls.Add(this.txtDebug);
            this.Controls.Add(this.lbApplications);
            this.Controls.Add(this.btnRun);
            this.Controls.Add(this.pnlScreen);
            this.Controls.Add(this.pictureBox1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(567, 544);
            this.MinimumSize = new System.Drawing.Size(567, 544);
            this.Name = "Form1";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "yoGomee Emulator";
            this.TopMost = true;
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.pnlScreen.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.axWebBrowser1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }



        #endregion

        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Panel pnlScreen;
        private System.Windows.Forms.Button btnRun;
        private System.Windows.Forms.ListBox lbApplications;
        private System.Windows.Forms.TextBox txtDebug;
        private AxSHDocVw.AxWebBrowser axWebBrowser1;
    }
}

