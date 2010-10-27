using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using yoGomee.Data.WebService;

namespace yoGomee.Data
{
    public partial class YoGomeeUser
    {
        /// <summary>
        /// Gets all the Application in the database 
        /// </summary>
        public static Boolean IsEmailRegisted(String Email)
        {
            Database db = DatabaseFactory.CreateDatabase();
            DbCommand dbCommand = db.GetStoredProcCommand("HG_IsEmailRegisted");
            db.AddInParameter(dbCommand, "Email", DbType.String, Email);

            Boolean IsAlreadyRegistered = false;

            //execute the stored procedure
            using (IDataReader dr = db.ExecuteReader(dbCommand))
            {
                if (dr.Read())
                {
                    IsAlreadyRegistered = true;
                }

                dr.Close();
            }

            return IsAlreadyRegistered;
        }

        public static List<JSONSearchResult> SearchByName(String SearchString)
        {
            Database db = DatabaseFactory.CreateDatabase();
            DbCommand dbCommand = db.GetStoredProcCommand("HG_SearchByName");
            db.AddInParameter(dbCommand, "SearchString", DbType.String, SearchString);

            List<JSONSearchResult> SearchResults = new List<JSONSearchResult>();

            //execute the stored procedure
            using (IDataReader dr = db.ExecuteReader(dbCommand))
            {
                while (dr.Read())
                {
                    var Result = new JSONSearchResult();
                    Result.UserID = dr["UserID"].ToString();
                    Result.FullName = (String)dr["FullName"];
                    Result.ISOCountry = (String)dr["ISOCountry"];
                    Result.LocationName = (String)dr["LocationName"];
                    Result.PhotoURL = (String)dr["PhotoURL"];

                    SearchResults.Add(Result);
                }

                dr.Close();
            }

            return SearchResults;
        }




        /// <summary>
        /// Gets all the Application in the database 
        /// </summary>
        public static YoGomeeUser Login(String Email, String Password)
        {
            Database db = DatabaseFactory.CreateDatabase();
            DbCommand dbCommand = db.GetStoredProcCommand("HG_Login");
            db.AddInParameter(dbCommand, "Email", DbType.String, Email);
            db.AddInParameter(dbCommand, "Password", DbType.String, Password);

            List<YoGomeeUser> arr = null;

            //execute the stored procedure
            using (IDataReader dr = db.ExecuteReader(dbCommand))
            {
                arr = PopulateObject(dr);
                dr.Close();
            }

            if (arr.Count > 0)
            {
                return arr[0];
            }
            else
            {
                return null;
            }
        }
    }
}
