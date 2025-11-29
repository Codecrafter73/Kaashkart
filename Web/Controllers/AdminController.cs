using Kaasht_Kart.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Kaasht_Kart.Controllers
{
    public class AdminController : Controller
    {
        Businesslayer bl = new Businesslayer();
        public ActionResult dashboard()
        {
            return View();
        }
        public ActionResult addproduct()
        {
            List<categorymodel> categories = new List<categorymodel>();


            try
            {
                // ✅ Load all categories for dropdown
                categories = bl.GetCategories() ?? new List<categorymodel>();

              
            }
            catch (Exception ex)
            {
                // ✅ Show friendly error message
                ViewBag.Message = $"⚠️ Unable to load data right now. {ex.Message}";
            }
            finally
            {
                // ✅ Always ensure ViewBag values exist (even if exception occurs)
                ViewBag.Categories = categories;
             
              
            }

            return View();
        }

        [HttpPost]
      
        public ActionResult addproduct(productmodel model)
        {
            try
            {
                string result = bl.AddProduct(model);

                if (!result.StartsWith("Error"))
                {
                    TempData["Success"] = result;   // Product added successfully
                    return RedirectToAction("addproduct");  // reload page
                }
                else
                {
                    TempData["Error"] = result;    // show error message
                    return RedirectToAction("addproduct");
                }
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Error: " + ex.Message;
                return RedirectToAction("addproduct");
            }
        }



        public ActionResult productlist()
        {
            List<productmodel> products = new List<productmodel>();
            products = bl.GetAllProducts() ?? new List<productmodel>();
            ViewBag.Products = products;
            return View();
        }
        public ActionResult order()
        {

            return View();
        }
        public ActionResult orderdetails()
        {

            return View();
        }
        public ActionResult addcategory()
        {
            List<categorymodel> categories = new List<categorymodel>();
            try
            {
                // ✅ Call business layer directly
                categories = bl.GetCategories();
            }
            catch (Exception)
            {
                ViewBag.Message = "⚠️ Unable to load categories right now.";
            }

            // ✅ Ensure ViewBag never null
            ViewBag.Categories = categories ?? new List<categorymodel>();
            return View();
        }
        [HttpPost]
        public ActionResult AddCategory(categorymodel model)
        {
            string message = bl.AddCategory(model);
            ViewBag.Message = message;
            return RedirectToAction("AddCategory");
        }

        [HttpPost]
        public JsonResult UpdateCategoryStatus(int id, bool status)
        {
            int result = bl.UpdateCategoryStatus(id, status);

            if (result > 0)
            {
                string msg = status
                    ? "✅ Category Activated Successfully!"
                    : "⛔ Category Deactivated Successfully!";

                string icon = status ? "success" : "warning";  // ✅ Different icon

                return Json(new { success = true, message = msg, icon = icon });
            }
            else
            {
                return Json(new { success = false, message = "⚠️ Something went wrong!", icon = "error" });
            }
        }

        [HttpPost]
      
        public JsonResult UpdateCategory(categorymodel model)
        {
            try
            {
                string imagePath = model.categoryimagepath;

                if (Request.Files.Count > 0)
                {
                    var file = Request.Files[0];
                    if (file != null && file.ContentLength > 0)
                    {
                        string fileName = Path.GetFileName(file.FileName);
                        string path = Path.Combine(Server.MapPath("~/Content/AdminFile/Products/Categoryimage/"), fileName);
                        file.SaveAs(path);
                        imagePath = fileName;
                    }
                }

                // Call Business Layer
              
                bool result = bl.UpdateCategoryDL(model.categoryid, model.categoryname, imagePath);

                return Json(new { success = result });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        public ActionResult VendorList()
        {
            var vendors = bl.GetVendorList();
            ViewBag.venderlist = vendors;   // Only count should go in ViewBag
            return View(vendors);                   // Pass model to view
        }

        [HttpPost]
 
        public JsonResult UpdateVendorStatus(int vendorId, bool status)
        {
            int result = bl.UpdateVendorStatus(vendorId, status);

            if (result > 0)
            {
                string msg = status
                    ? "Vendor approved & email sent ✅"
                    : "Vendor deactivated ❌";

                return Json(new { success = true, message = msg });
            }
            else
            {
                return Json(new { success = false, message = "Error updating status!" });
            }
        }

        //public ActionResult VendorDetails(string vendorId)
        //{
        //    if (string.IsNullOrEmpty(vendorId))
        //        return RedirectToAction("VendorList");

        //    var vendorModel = bl.GetVendorDetailsWithProduct(vendorId);
        //    return View(vendorModel);
        //}

        public ActionResult slidermaster()
        {
            DataTable dt = bl.getallslider();
            ViewBag.sliderlist = dt;
            return View();
        }

        [HttpPost]
        public ActionResult slidermaster(bannermodel model)
        {
            try
            {
                if (model.imagefile == null || model.imagefile.ContentLength == 0)
                {
                    TempData["msg"] = "❌ Please select an image!";
                    return RedirectToAction("slidermaster");
                }

                int result = bl.AddSlider(model);

                if (result > 0)
                    TempData["msg"] = "✅ Banner Added Successfully!";
                else
                    TempData["msg"] = "❌ Failed to add banner";
            }
            catch (Exception ex)
            {
                TempData["msg"] = "❌ Error: " + ex.Message;
            }

            return RedirectToAction("slidermaster");
        }

        [HttpPost]
        public JsonResult UpdateSliderStatus(int sliderId, bool status)
        {
            try
            {
                int result = bl.UpdateSliderStatus(sliderId, status);
                if (result > 0)
                {
                    string msg = status ? "✅ Slider Activated Successfully!" : "❌ Slider Deactivated Successfully!";
                    return Json(new { success = true, message = msg });
                }
                else
                {
                    return Json(new { success = false, message = "⚠️ Failed to update status." });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "❌ Error: " + ex.Message });
            }
        }


        public JsonResult ChangeStatus(int id, bool status)
        {
            try
            {
                bool result = bl.ChangeProductStatus(id, status);

                if (result)
                {
                    return Json(new { success = true, message = "Product status updated successfully!" });
                }
                else
                {
                    return Json(new { success = false, message = "Failed to update product status." });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "An error occurred: " + ex.Message });
            }
        }

    }
}