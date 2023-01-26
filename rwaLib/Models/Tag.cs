using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace rwa.Models
{
    public class Tag
    {
        public int Id { get; set; }
        public Guid? Guid { get; set; }
        public DateTime? DateTime { get; set; }
        public string Name { get; set; }
        public string NameEng { get; set; }
        public int? TypeId { get; set; }

        public Tag()
        {
        }

        public Tag(string name, string nameEng, int? typeId)
        {
            Name = name;
            NameEng = nameEng;
            TypeId = typeId;
        }
    }
}