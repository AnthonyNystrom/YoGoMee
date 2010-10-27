using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace yoGomee.Data
{
    public partial class Gomee
    {
        /// <summary>
        /// Gets all the Application in the database 
        /// </summary>
        public static void Delete(int GomeeID)
        {

            Database db = DatabaseFactory.CreateDatabase();
            DbCommand dbCommand = db.GetStoredProcCommand("HG_DeleteGomee");
            db.AddInParameter(dbCommand, "GomeeID", DbType.Int32, GomeeID);

            try
            {
                db.ExecuteNonQuery(dbCommand);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Gets all the gomees for a user
        /// </summary>
        public static List<Gomee> GetGomeesForMe(int YoGomeeUserID)
        {

            Database db = DatabaseFactory.CreateDatabase();
            DbCommand dbCommand = db.GetStoredProcCommand("HG_GetGomeesForMe");
            db.AddInParameter(dbCommand, "YoGomeeUserID", DbType.Int32, YoGomeeUserID);

            List<Gomee> arr = new List<Gomee>();

            using (IDataReader dr = db.ExecuteReader(dbCommand))
            {
                arr = PopulateObject(dr);
                dr.Close();
            }

            return arr;
        }


        /// <summary>
        /// Gets all the gomees that the user has laid
        /// </summary>
        public static List<Gomee> GetMyGomees(int YoGomeeUserID)
        {
            Database db = DatabaseFactory.CreateDatabase();
            DbCommand dbCommand = db.GetStoredProcCommand("HG_GetMyGomees");
            db.AddInParameter(dbCommand, "YoGomeeUserID", DbType.Int32, YoGomeeUserID);

            List<Gomee> arr = new List<Gomee>();

            using (IDataReader dr = db.ExecuteReader(dbCommand))
            {
                arr = PopulateObject(dr);
                dr.Close();
            }

            return arr;
        }
    }
}
