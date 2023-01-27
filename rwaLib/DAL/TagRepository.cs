using Microsoft.ApplicationBlocks.Data;
using rwaLib.Models;
using rwaLib.Models.ViewModels;
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
                var tag = new Tag
                {
                    Id = Convert.ToInt32(row["ID"]),
                    Name = row["Name"].ToString()
                };
                tagList.Add(tag);
            }
            return tagList;
        }

        public List<TagCount> GetTagCount()
        {
            var ds = SqlHelper.ExecuteDataset(
            _connectionString,
            nameof(GetTagCount));
            var tagList = new List<TagCount>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                var tag = new TagCount();
                tag.id = Convert.ToInt32(row["Id"]);
                tag.name = row["Name"].ToString();
                tag.count = Convert.ToInt32(row["Total"]);
                tagList.Add(tag);
            }
            return tagList;
        }

        public void InsertTag(Tag tag)
        {
            SqlHelper.ExecuteNonQuery(_connectionString, nameof(InsertTag), tag.TypeId,tag.Name, tag.NameEng);
        }

        public void DeleteTag(int id)
        {
            SqlHelper.ExecuteNonQuery(_connectionString, nameof(DeleteTag), id);
        }

    }
}