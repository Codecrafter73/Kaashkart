using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class CartItemModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Image { get; set; }
        public int Qty { get; set; }
        public decimal Price { get; set; }

        public decimal Total
        {
            get { return Price * Qty; }
        }
    }


    public class CheckoutViewModel
    {
        public string UserName { get; set; }
        public string Mobile { get; set; }
        public string Address { get; set; }
        public string Email { get; set; }

        public List<CartItemModel> CartItems { get; set; }

        public decimal GrandTotal { get; set; }
    }
    public class OrderListModel
    {
        public int OrderId { get; set; }
        public decimal GrandTotal { get; set; }
        public string OrderStatus { get; set; }
        public DateTime OrderDate { get; set; }

        // List of Product Items inside each order
        public List<OrderItemModel> Items { get; set; } = new List<OrderItemModel>();
    }

    public class OrderItemModel
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string ProductImageUrl { get; set; }
        public int Qty { get; set; }
        public decimal Price { get; set; }
        public decimal Total { get; set; }
    }

}
