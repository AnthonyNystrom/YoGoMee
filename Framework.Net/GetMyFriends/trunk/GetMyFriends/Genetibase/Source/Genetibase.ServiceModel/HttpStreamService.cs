/* ------------------------------------------------
 * HttpStreamService.cs
 * Copyright © 2008 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Drawing;
using System.IO;
using System.Text;

namespace Genetibase.ServiceModel
{
    public static class HttpStreamService
    {
        public static Image ConvertToImageFromStream(String imageStream)
        {
            if (imageStream == null)
                throw new ArgumentNullException("imageStream");

            return Image.FromStream(new MemoryStream(Encoding.Default.GetBytes(imageStream)));
        }

        public static Image ConvertToImageFromStream(Stream imageStream)
        {
            if (imageStream == null)
                throw new ArgumentNullException("imageStream");

            return Image.FromStream(imageStream);
        }
    }
}
