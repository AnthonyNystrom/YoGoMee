using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace yoGomee.Data
{
    public class UniqueID
    {
        public static string New8ID()
        {
            string guid = Guid.NewGuid().ToString().Replace("-", string.Empty);
            byte[] bytes = System.Text.Encoding.UTF8.GetBytes(guid);

            return Convert.ToBase64String(bytes).Substring(0, 8);
        }
    }
}
