using rwaLib.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace rwaLib.DAL
{
    public class OrderRepository
    {
        public List<Order> GetOrders()
        {
            return new List<Order>
             {
                 new Order { Id = 0, Name = "(kriterij sortiranja)" },
                 new Order { Id = 1, Name = "BrojSoba" },
                 new Order { Id = 2, Name = "BrojOdraslih" },
                 new Order { Id = 3, Name = "BrojDjece" },
                 new Order { Id = 4, Name = "Cijena" },
              };
        }
    }
}