using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace rwaLib.Models
{
    public class SearchModel
    {
        public int? FilterRooms { get; set; }
        public int? FilterAdults { get; set; }
        public int? FilterChildren { get; set; }


        public int? FilterCity { get; set; }
        public List<City> CityList { get; set; }


        public int? Order { get; set; }
        public List<Order> OrderList { get; set; }

        public List<SearchResultModel> SearchResult { get; set; }


    }
}
