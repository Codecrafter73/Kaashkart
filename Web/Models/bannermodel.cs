using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class bannermodel
    {
        public int SliderId { get; set; }
        public HttpPostedFileBase imagefile { get; set; }
        public string imagefilepath { get; set; }
        public string bannername { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}