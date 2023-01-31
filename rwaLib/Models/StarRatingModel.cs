using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace rwaLib.Models
{
    public class StarRatingModel
    {
        public string Question { get; set; }
        public int Rating { get; set; }
        public int MaxRating { get; set; } = 5;
    }
}
