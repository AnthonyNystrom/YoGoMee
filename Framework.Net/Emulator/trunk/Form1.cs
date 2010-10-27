using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace yoGomee.Emulator
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();
            RefreshAppListBox();
        }

        private void txtRun_Click(object sender, EventArgs e)
        {
            Run();
        }

        private void Run()
        {
            txtDebug.Text = "Executing code server-side.. please wait";

            try
            {
                this.Cursor = Cursors.WaitCursor;
                btnRun.Enabled = false;
                ws.Emulator emulator = new ws.Emulator();
                string ApplicationName = lbApplications.SelectedItem.ToString();
                ws.ExecutionResponse Response = emulator.RunApplication(ApplicationName);

                DoAction(Response.YogoAction);
                txtDebug.Text = Response.DebugText;
            }
            catch (Exception ex)
            {
                txtDebug.Text = "web service error:" + Environment.NewLine + ex.ToString();
            }

            btnRun.Enabled = true;
            this.Cursor = Cursors.Default;   
        }

        private void DoAction(ws.YogoAction action)
        {
            try
            {
                object empty = System.Reflection.Missing.Value;
                axWebBrowser1.Navigate("about:blank", ref empty, ref empty, ref empty, ref empty);
            }
            catch { }

            pnlScreen.Controls.Clear();

            if (action == null)
            {
                return;
            }

            if (action.ActionType == ws.ActionType.Text)
            {
                ShowText(action);
            }
            else if (action.ActionType == ws.ActionType.Image)
            {
                ShowImage(action);
            }
            else if (action.ActionType == ws.ActionType.Browser)
            {
                ShowBrowser(action);
            }
        }

        private void RefreshAppListBox()
        {
            
            ws.Emulator emulator = new ws.Emulator();
            string[] Apps = emulator.GetApplicationList();

            lbApplications.Items.AddRange(Apps);

            lbApplications.SelectedIndex = 0;
        }

        private void ShowImage(ws.YogoAction action)
        {
            Bitmap image = Phone.GetImageFromUrl(action.ImageUrl);

            PictureBox pic = new PictureBox();
            pic.Image = image;
            pic.Size = pnlScreen.Size;
            pic.SizeMode = PictureBoxSizeMode.Zoom;
            pnlScreen.Controls.Add(pic);
        }

        private void ShowText(ws.YogoAction action)
        {
            Label lbl = new Label();
            lbl.Text = action.TextToDisplay;
            lbl.Size = pnlScreen.Size;
            pnlScreen.Controls.Add(lbl);
        }

        private void ShowBrowser(ws.YogoAction action)
        {
            object empty = System.Reflection.Missing.Value;

            axWebBrowser1.Navigate(action.UrlToNavigateTo, ref empty, ref empty, ref empty, ref empty);
            pnlScreen.Controls.Add(axWebBrowser1);
        }

        private void btnRefreshServices_Click(object sender, EventArgs e)
        {
            RefreshAppListBox();
        }

        void lbApplications_DoubleClick(object sender, System.EventArgs e)
        {
            Run();
        }

    }
}
