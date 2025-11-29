using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class Order
    {
        public int OrderId { get; set; }

        // Customer
        public int UserId { get; set; }
        public string CustomerName { get; set; }
        public string Mobile { get; set; }
        public string Address { get; set; }
        public decimal TotalAmount { get; set; }   // FIXED
        public string Email { get; set; }
        public string DeliveryAddress { get; set; }

        // Price summary
        public int TotalItems { get; set; }
        public decimal SubTotal { get; set; }
        public decimal Shipping { get; set; }
        public decimal Tax { get; set; }
        public decimal GrandTotal { get; set; }

        // Payment
        public string PaymentMethod { get; set; }
        public string PaymentStatus { get; set; }

        public string OrderStatus { get; set; }

        // Cart items JSON
        public string CartJson { get; set; }

        public DateTime OrderDate { get; set; }
    }

    public class OrderRequestModel
    {
        public string PaymentMethod { get; set; }
    }

}