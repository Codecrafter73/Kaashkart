using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class categorymodel
    {
        public int categoryid { get; set; }
        public HttpPostedFileBase categoryimage { get; set; }
        public string categoryname { get; set; }
        public string categorydes { get; set; }
        public bool categorystatus { get; set; }

        //✅ File name coming from database
        public string categoryimagepath { get; set; }


    }
}