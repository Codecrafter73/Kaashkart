using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class UserModel
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string MobileNumber { get; set; }
        public string Address { get; set; }
        public string Gender { get; set; }
        public string ProfileImage { get; set; }

        public DateTime? DateOfBirth { get; set; }
      
    }
}