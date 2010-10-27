using System;
using System.IO;
using System.Net;
using System.Drawing;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using yoGomee.Data;

namespace yoGomee.Emulator
{
    public class Phone
    {
        public List<Contact> Contacts;
        public List<Sms> SMS;
        public List<Location> Locations;

        public static Bitmap GetImageFromUrl(string ImageUrl)
        {
            byte[] b;
            HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create(ImageUrl);
            WebResponse myResp = myReq.GetResponse();

            Stream stream = myResp.GetResponseStream();
            //int i;
            using (BinaryReader br = new BinaryReader(stream))
            {
                //i = (int)(stream.Length);
                b = br.ReadBytes(500000);
                br.Close();
            }
            myResp.Close();


            MemoryStream ms = new MemoryStream(b);

            Bitmap image = new Bitmap(ms);

            return image;
        }
    }
}
