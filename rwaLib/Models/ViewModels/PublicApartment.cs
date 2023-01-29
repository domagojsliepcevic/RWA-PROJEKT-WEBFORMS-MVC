using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace rwaLib.Models.ViewModels
{
    public class PublicApartment
    {

        public int Id { get; set; }
        public string Name { get; set; }
        public int? StarRating { get; set; }
        public string CityName { get; set; }
        public int? BeachDistance { get; set; }
        public int? TotalRooms { get; set; }
        public int? MaxAdults { get; set; }
        public int? MaxChildren { get; set; }
        public string OwnerName { get; set; }

        public List<Tag> Tags { get; set; }
        public List<ApartmentPicture> Pictures { get; set; }


    }
}
