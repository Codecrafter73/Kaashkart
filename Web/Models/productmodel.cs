using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Kaasht_Kart.Models
{

    public class productmodel
    {
        public int ProductId { get; set; }

        public string CategoryName { get; set; }
        public string ProductName { get; set; }
        public string tagline { get; set; }

        // Description + Extra CKEditor fields
        [AllowHtml]
        public string Description { get; set; }

        [AllowHtml]
        public string UsageInfo { get; set; }

        [AllowHtml]
        public string Benefits { get; set; }

        [AllowHtml]
        public string StorageInfo { get; set; }

        [AllowHtml]
        public string Faq { get; set; }

        // ----------------------------------
        // Dynamic Weight / Price Rows
        // ----------------------------------
        public List<string> UnitQuantity { get; set; }
        public List<string> Unit { get; set; }
        public List<decimal> Price { get; set; }
        public List<decimal> Discount { get; set; }
        public List<decimal> FinalPrice { get; set; }
        public List<int> Stock_Quantity { get; set; }

        // ----------------------------------
        // Image Upload Fields
        // ----------------------------------

        // Main product image upload
        public HttpPostedFileBase ProductImage { get; set; }

        // Main image path in DB
        public string ProductImagePath { get; set; }

        // Multiple sub image upload
        public List<HttpPostedFileBase> ProductSubImageUpload { get; set; }

        // Multiple sub image paths in DB
        public List<string> ProductSubImage { get; set; }

        // ----------------------------------
        // Extra Fields
        // ----------------------------------
        public string Status { get; set; }
        public DateTime Created_At { get; set; }
        public DateTime Updated_At { get; set; }


    }



    public class venderlogin
    {
        public string loginEmail { get; set; }
        public string loginPassword { get; set; }
    }

    public class CategoryProductsViewModel
    {
        public List<productmodel> Products { get; set; }
        public List<VendorProductModel> VendorProducts { get; set; }
    }




}