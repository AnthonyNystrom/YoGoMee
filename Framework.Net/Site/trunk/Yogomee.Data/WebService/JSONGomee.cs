using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace yoGomee.Data.WebService
{
    public class JSONGomee
    {
        public float Latitude { get; set; }
        public float Longitude { get; set; }
        public DateTime Expiration { get; set; }
        public bool DoesExpire { get; set; }
        public int GomeeType { get; set; }
        public string RawValue1 { get; set; }
        public string RawValue2 { get; set; }

        public static JSONGomee[] ConvertToJSONGomee(List<Gomee> Gomees)
        {
            JSONGomee[] JsonGomees = new JSONGomee[Gomees.Count];

            for (int i = 0; i < Gomees.Count; i++)
            {
                var JsonGomee = new JSONGomee();
                JsonGomee.Latitude = (float)Gomees[i].Latitude;
                JsonGomee.Longitude = (float)Gomees[i].Longitude;
                JsonGomee.Expiration = Gomees[i].Expiration;
                JsonGomee.GomeeType = Gomees[i].GomeeType;
                JsonGomee.DoesExpire = Gomees[i].DoesExpire;
                JsonGomee.RawValue1 = Gomees[i].RawValue1;
                JsonGomee.RawValue2 = Gomees[i].RawValue2;

                JsonGomees[i] = JsonGomee;
            }

            return JsonGomees;
        }
    }
}
