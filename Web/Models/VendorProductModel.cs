using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class VendorProductModel
    {
        public int ProductId { get; set; }
        public string VendorId { get; set; }
        public string Vendorunique { get; set; }
        public string categoryname { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public decimal Discount { get; set; }
        public decimal FinalPrice { get; set; }
        public int StockQuantity { get; set; }
        public string unitquantity { get; set; }
        public string Unit { get; set; }

        public HttpPostedFileBase ProductImageFile { get; set; }
        public List<HttpPostedFileBase> productsubimageupload { get; set; }

        public string ProductImage { get; set; }
        public List<string> productsubimage { get; set; }
        public string Description { get; set; }
        public DateTime Created_Date { get; set; }
        public bool Status { get; set; }
    }


    public class CategoryWiseProductsViewModel
    {
        public List<productmodel> AdminProducts { get; set; }
        public List<VendorProductModel> VendorProducts { get; set; }
        public string CategoryName { get; set; }
    }

    public class PaymentViewModel
    {
        public List<CartItemModel> CartItems { get; set; }
        public decimal GrandTotal { get; set; }

        public string CustomerName { get; set; }
        public string Mobile { get; set; }
        public string Address { get; set; }
    }



}