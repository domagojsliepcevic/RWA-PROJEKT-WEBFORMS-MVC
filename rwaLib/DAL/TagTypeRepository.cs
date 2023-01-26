using Microsoft.ApplicationBlocks.Data;
using rwaLib.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;

namespace rwaLib.DAL
{
    public class TagTypeRepository
    {
        private readonly string _connectionString;

        public TagTypeRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["rwadb"].ConnectionString;
        }

        public List<TagType> GetTagTypes()
        {
            List<TagType> tagTypes = new List<TagType>();
            var tbltagTypes = SqlHelper.ExecuteDataset(_connectionString, nameof(GetTagTypes)).Tables[0];

            foreach (DataRow row in tbltagTypes.Rows)
            {
                tagTypes.Add(new TagType
                {
                    Id = (int)row[nameof(TagType.Id)],
                    Guid = (Guid)row[nameof(TagType.Guid)],
                    Name = row[nameof(TagType.Name)].ToString(),
                    NameEng = row[nameof(TagType.NameEng)].ToString()

                });

            }
            return tagTypes;
        }
    }
}
