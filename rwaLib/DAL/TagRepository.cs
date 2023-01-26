using Microsoft.ApplicationBlocks.Data;
using rwa.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;

namespace rwaLib.DAL
{
    public class TagRepository
    {
        private readonly string _connectionString;
        public TagRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["rwadb"].ConnectionString;
        }
        public List<Tag> GetTags()
        {
            var ds = SqlHelper.ExecuteDataset(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.GetTags");
            var tagList = new List<Tag>();
            tagList.Add(new Tag { Id = 0, Name = "(odabir taga)" });
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                var tag = new Tag();
                tag.Id = Convert.ToInt32(row["ID"]);
                tag.Name = row["Name"].ToString();
                tagList.Add(tag);
            }
            return tagList;
        }
    }
}