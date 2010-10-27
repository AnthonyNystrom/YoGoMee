using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace yoGomee.Data
{
    /// <summary>
    /// Returns the path for the users gomee data
    /// </summary>
    public class GomeeFileManager
    {
        private YoGomeeUser User = null;

        public GomeeFileManager(int UserID)
        {
            User = new YoGomeeUser(UserID);
        }

        /// <summary>
        /// returns the user root directory
        /// </summary>
        public string UserRoot
        {

            get
            {
                // get the web root
                string ExePath = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().GetName().CodeBase);
                Uri uri = new Uri(ExePath);
                DirectoryInfo d = new DirectoryInfo(uri.LocalPath);
                var websiteRootDir = d.Parent.FullName;

                string Path = websiteRootDir + @"\gomeedata\" + User.YoGomeeUserID + @"\";

                if (!Directory.Exists(Path))
                {
                    Directory.CreateDirectory(Path);
                }

                return Path;
            }
        }

        public static string WebRoot
        {

            get
            {
                // get the web root
                string ExePath = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().GetName().CodeBase);
                Uri uri = new Uri(ExePath);
                DirectoryInfo d = new DirectoryInfo(uri.LocalPath);
                var websiteRootDir = d.Parent.FullName + @"\";

                return websiteRootDir;
            }
        }

        /// <summary>
        /// returns the Profile photo directory for the user
        /// </summary>
        public string ProfilePhotoDirectory
        {
            get
            {
                string Path = UserRoot + @"ProfilePhoto\";

                if (!Directory.Exists(Path))
                {
                    Directory.CreateDirectory(Path);
                }

                return Path;
            }
        }

        /// <summary>
        /// returns the Gomee photo directory
        /// </summary>
        public string GomeePhotoDirectory
        {
            get
            {
                string Path = UserRoot + @"Photo\";

                if (!Directory.Exists(Path))
                {
                    Directory.CreateDirectory(Path);
                }

                return Path;
            }
        }


        /// <summary>
        /// returns the sound photo directory
        /// </summary>
        public string GomeeSoundDirectory
        {
            get
            {
                string Path = UserRoot + @"\Sound\";

                if (!Directory.Exists(Path))
                {
                    Directory.CreateDirectory(Path);
                }

                return Path;
            }
        }



    }
}
