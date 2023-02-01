using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace rwaLib.Models.ViewModels
{
    public class ContactReservationModel
    {


        public int ApartmentId { get; set; }

        [Required]
        public string FirstName { get; set; }

        [Required]
        public string LastName { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        public string PhoneMobile { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Number of adults must be greater than 0")]
        public int NumberOfAdults { get; set; }

        [Required]
        public int? NumberOfChildren { get; set; }
    }
}
