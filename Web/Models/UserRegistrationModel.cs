using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class UserRegistrationModel
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string MobileNumber { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string Gender { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Address { get; set; }
        public bool TermsAccepted { get; set; }
    }



}