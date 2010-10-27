using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace yoGomee.Data.WebService
{
    public class JSONSearchResult
    {
        public string UserID { get; set; }
        public string FullName { get; set; }
        public string LocationName { get; set; }
        public string ISOCountry { get; set; }
        public string PhotoURL { get; set; }
        public int number { get; set; }
        public DateTime  date { get; set; }
    }
}
