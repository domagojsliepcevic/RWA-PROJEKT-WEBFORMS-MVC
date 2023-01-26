using rwa.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace rwaLib.DAL
{
    public class StatusRepository
    {
        public List<Status> GetStatuses()
        {
            return new List<Status>
                 {
                 new Status { Id = 0, Name = "(odabir statusa)" },
                 new Status { Id = 1, Name = "Zauzeto" },
                 new Status { Id = 2, Name = "Rezervirano" },
                 new Status { Id = 3, Name = "Slobodno" },
                 };
        }
    }
}