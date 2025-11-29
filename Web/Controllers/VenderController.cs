using Kaasht_Kart.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Kaasht_Kart.Controllers
{
    public class VenderController : Controller
    {
        Businesslayer bl = new Businesslayer();
       
        public ActionResult venderdashbaord()
        {
              
            //if (Session["VendorEmail"] == null);
            //{
            //    return RedirectToAction("registration", "Customer");
            //}

            return View();
        }
        public ActionResult venderproduct()
        {
            // ✅ Load categories
            ViewBag.Categories = bl.GetCategories() ?? new List<categorymodel>();

            // ✅ Check Vendor login
            if (Session["VendorId"] == null)
            {
                return RedirectToAction("registration", "Customer");
            }

            // ✅ Get VendorId from Session
            string vendorId = Session["VendorId"].ToString();
            ViewBag.VendorId = vendorId;

            // ✅ Get vendor products
            var vendorProducts = bl.GetVendorProducts(vendorId);

            return View(vendorProducts);
        }


        [HttpPost]
        public ActionResult addvenderproduct(VendorProductModel model,string VenderId)
        {
            try
            {
                VenderId = Session["VendorId"].ToString();
                string result = bl.SaveVendorProduct(model,VenderId);

                if (result == "success")
                {
                    return Json(new { success = true, message = "Product Added Successfully" });
                }
                else
                {
                    return Json(new { success = false, message = "Error occurred while saving product" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

    }
}