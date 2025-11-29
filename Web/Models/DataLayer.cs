using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class DataLayer
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connection"].ConnectionString);
        public int DML(string proc, SqlParameter[] para)
        {
            SqlCommand cmd = new SqlCommand(proc, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            foreach (SqlParameter param in para)
            {
                if (param != null)
                    cmd.Parameters.Add(param);
            }

            conn.Open();
            int res = cmd.ExecuteNonQuery();
            conn.Close();
            return res;

        }

        public DataTable ExecuteSelectParamenter(string proc, SqlParameter[] para)
        {
            SqlCommand cmd = new SqlCommand(proc, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            foreach (SqlParameter param in para)
            {
                if (param != null)
                    cmd.Parameters.Add(param);
            }
            DataTable dt = new DataTable();
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            sda.Fill(dt);
            return dt;

        }

        public DataTable ExecuteSelect(string proc)
        {
            SqlCommand cmd = new SqlCommand(proc, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            DataTable dt = new DataTable();
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            sda.Fill(dt);
            return dt;
        }

        public DataSet ExecuteSelectDataSet(string proc, SqlParameter[] para)
        {
            SqlCommand cmd = new SqlCommand(proc, conn);
            cmd.CommandType = CommandType.StoredProcedure;

            foreach (SqlParameter param in para)
            {
                if (param != null)
                    cmd.Parameters.Add(param);
            }

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }

    }
}