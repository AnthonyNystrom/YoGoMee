using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace yoGomee.Data
{
    public class ColumnFieldList
    {
        public List<string> Columns = new List<string>();

        public ColumnFieldList(IDataReader dr)
        {
            for (int i = 0; i < dr.FieldCount; i++)
            {
                Columns.Add(dr.GetName(i).ToUpper());
            }
        }

        public bool IsColumnPresent(string Name)
        {
            Name = Name.ToUpper();

            for (int i = 0; i < Columns.Count; i++)
            {
                if (Columns[i] == Name)
                    return true;
            }

            return false;
        }
    }
}
