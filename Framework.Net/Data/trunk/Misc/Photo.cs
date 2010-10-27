using System;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;
using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace yoGomee.Data
{
    public partial class Photo
    {

        public static bool IsPhotoFile(byte[] PhotoBytes)
        {
            try
            {
                Image image = ByteArrayToImage(PhotoBytes);
            }
            catch (Exception)
            {
                return false;
            }

            return true;
        }
 
        public static string SaveToDisk(string Base64String, string SaveToDirectory)
        {
            try
            {
                EncoderParameters EncoderParams = new EncoderParameters(2);
                EncoderParams.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, (long)90);
                EncoderParams.Param[1] = new EncoderParameter(System.Drawing.Imaging.Encoder.ColorDepth, (long)24);

                ImageCodecInfo imageCodecInfo = GetEncoderInfo("image/jpeg");

                Image ImageFile = Base64StringToImage(Base64String);

                string FileName = UniqueID.New8ID() + ".jpg";

                string SavePath = SaveToDirectory + FileName;

                ImageFile.Save(SavePath, imageCodecInfo, EncoderParams);

                return FileName;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static Image ResizeImageWithRatio(Image ImageFile, double maxWidth, double maxHeight)
        {

            try
            {

                // Declare variable for the conversion
                float ratio;


                // Get height and width of current image
                int width = (int)ImageFile.Width;
                int height = (int)ImageFile.Height;

                // Ratio and conversion for new size
                if (width > maxWidth)
                {
                    ratio = (float)width / (float)maxWidth;
                    width = (int)(width / ratio);
                    height = (int)(height / ratio);
                }

                // Ratio and conversion for new size
                if (height > maxHeight)
                {
                    ratio = (float)height / (float)maxHeight;
                    height = (int)(height / ratio);
                    width = (int)(width / ratio);
                }

                // Create "blank" image for drawing new image
                Bitmap outImage = new Bitmap(width, height);
                Graphics outGraphics = Graphics.FromImage(outImage);
                SolidBrush sb = new SolidBrush(System.Drawing.Color.White);


                // Fill "blank" with new sized image
                outGraphics.FillRectangle(sb, 0, 0, outImage.Width, outImage.Height);
                outGraphics.DrawImage(ImageFile, 0, 0, outImage.Width, outImage.Height);
                sb.Dispose();
                outGraphics.Dispose();
                ImageFile.Dispose();


                return outImage;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static ImageCodecInfo GetEncoderInfo(String mimeType)
        {
            int j;
            ImageCodecInfo[] encoders;
            encoders = ImageCodecInfo.GetImageEncoders();
            for (j = 0; j < encoders.Length; ++j)
            {
                if (encoders[j].MimeType == mimeType)
                    return encoders[j];
            }
            return null;
        }

        public static byte[] ImageToByteArray(System.Drawing.Image imageIn)
        {
            MemoryStream ms = new MemoryStream();
            imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
            return ms.ToArray();
        }




        public static string ImageToBase64String(System.Drawing.Image imageIn)
        {
            MemoryStream ms = new MemoryStream();
            imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);

            return Convert.ToBase64String(ms.ToArray()); ;
        }

        public static Image Base64StringToImage(string Base64String)
        {
            byte[] byteImage = Convert.FromBase64String(Base64String);
            Image image = ByteArrayToImage(byteImage);

            return image;
        }

        public static Image ByteArrayToImage(byte[] byteArrayIn)
        {
            MemoryStream ms = new MemoryStream(byteArrayIn);
            Image returnImage = Image.FromStream(ms);
            return returnImage;
        }

        #region Omid - Centre Crop for thumbnails

        public static Image CropImageFromCenter(Image ImageFile, double cropWidth, double cropHeight)
        {
            int newWidth = (int)cropWidth;
            int newHeight = (int)cropHeight;
            Bitmap outImage = new Bitmap(newWidth, newHeight);

            try
            {
                using (Graphics outGraphics = Graphics.FromImage(outImage))
                {
                    Rectangle sourceRectangle = new Rectangle(
                        (ImageFile.Width - outImage.Width) / 2,
                        (ImageFile.Height - outImage.Height) / 2,
                        outImage.Width, // width of new rectengle
                        outImage.Height); // // Height of new rectengle

                    Rectangle destRectangle = new Rectangle(0, 0, outImage.Width, outImage.Height);

                    SolidBrush sb = new SolidBrush(System.Drawing.Color.White);
                    outGraphics.FillRectangle(sb, 0, 0, outImage.Width, outImage.Height);
                    outGraphics.DrawImage(ImageFile, destRectangle, sourceRectangle, GraphicsUnit.Pixel);
                    sb.Dispose();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return outImage;
        }

        public static Image ScaleCropImageFromCenter(Image ImageFile, double cropWidth, double cropHeight)
        {
            int newWidth = (int)cropWidth;
            int newHeight = (int)cropHeight;

            Bitmap outImage = new Bitmap(newWidth, newHeight);

            float ratio = 1.0f;


            // Get height and width of current image
            int width = (int)ImageFile.Width;
            int height = (int)ImageFile.Height;

            // Ratio and conversion for new size
            if (((float)width / (float)cropWidth) <
                ((float)height / (float)cropHeight))
            {
                ratio = (float)width / (float)cropWidth;
            }
            else
            {

                ratio = (float)height / (float)cropHeight;
            }

            Rectangle sourceRectangle = new Rectangle(
                       (int)((ImageFile.Width - outImage.Width * ratio)) / 2,
                       (int)((ImageFile.Height - outImage.Height * ratio)) / 2,
                       (int)(outImage.Width * ratio), // width of new rectengle
                       (int)(outImage.Height * ratio)); // // Height of new rectengle

            Rectangle destRectangle = new Rectangle(0, 0, outImage.Width, outImage.Height);


            try
            {
                using (Graphics outGraphics = Graphics.FromImage(outImage))
                {


                    SolidBrush sb = new SolidBrush(System.Drawing.Color.White);
                    //   outGraphics.FillRectangle(sb, 0, 0, outImage.Width, outImage.Height);
                    outGraphics.DrawImage(ImageFile, destRectangle, sourceRectangle, GraphicsUnit.Pixel);

                    sb.Dispose();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return outImage;
        }

        #endregion

    }

}