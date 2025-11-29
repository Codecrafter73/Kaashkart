using Kaasht_Kart.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Kaasht_Kart.Controllers
{
    public class AccountController : BaseController
    {
        Businesslayer bl = new Businesslayer();
        DataLayer dl = new DataLayer();

        // Email/Password Login
        [HttpPost]
        public JsonResult LoginByEmail(UserRegistrationModel user)
        {
            try
            {
                DataTable dt = bl.LoginByEmail(user);

                if (dt != null && dt.Rows.Count > 0)
                {
                    // Get user ID
                    string userId = dt.Rows[0]["UserId"].ToString();

                    // Set login sessions
                    Session["UserId"] = userId;
                    Session["UserName"] = dt.Rows[0]["UserName"].ToString();
                    Session["MobileNumber"] = dt.Rows[0]["MobileNumber"].ToString();
                    Session["Email"] = dt.Rows[0]["Email"].ToString();
                    Session["Address"] = dt.Rows[0]["Address"].ToString();

                    // ✅ Return userId to trigger cart migration in JavaScript
                    return Json(new
                    {
                        success = true,
                        message = "Login successful",
                        userId = userId  // 🆕 Send userId to frontend
                    });
                }
                else
                {
                    return Json(new { success = false, message = "Invalid Email or Password" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        // 🔹 Check Mobile Exists (for OTP Login)
        [HttpPost]
        public JsonResult CheckMobile(string mobile)
        {
            try
            {
                DataTable dt = bl.CheckMobileExists(mobile);

                if (dt.Rows.Count > 0)
                {
                    // Get user ID
                    string userId = dt.Rows[0]["UserId"].ToString();

                    // SET USER SESSION
                    Session["UserId"] = userId;
                    Session["UserName"] = dt.Rows[0]["UserName"].ToString();
                    Session["MobileNumber"] = dt.Rows[0]["MobileNumber"].ToString();
                    Session["Email"] = dt.Rows[0]["Email"].ToString();
                    Session["Address"] = dt.Rows[0]["Address"].ToString();

                    // Generate OTP
                    string otp = new Random().Next(100000, 999999).ToString();
                    Session["OTP"] = otp;

                    // ✅ Return userId for cart migration
                    return Json(new
                    {
                        success = true,
                        otp = otp,
                        message = "OTP sent successfully",
                        userId = userId  // 🆕 Send userId to frontend
                    });
                }
                else
                {
                    return Json(new { success = false, message = "Mobile number not registered" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        // 🔹 Verify OTP
        [HttpPost]
        public JsonResult VerifyOtp(string otp)
        {
            if (Session["OTP"] != null && Session["OTP"].ToString() == otp)
            {
                // Get userId from session
                string userId = Session["UserId"]?.ToString() ?? "";

                // ✅ Return userId for cart migration
                return Json(new
                {
                    success = true,
                    message = "Login successful",
                    userId = userId  // 🆕 Send userId to frontend
                });
            }

            return Json(new { success = false, message = "Invalid OTP" });
        }

        public ActionResult profile()
        {
            if (Session["UserId"] == null)
                return RedirectToAction("userlogin");

            int userId = Convert.ToInt32(Session["UserId"]);

            // Fetch logged-in user details
            SqlParameter[] parameters =
            {
                new SqlParameter("@UserId", userId)
            };

            DataTable dt = dl.ExecuteSelectParamenter("sp_GetUserDetails", parameters);
            ViewBag.Data = dt;


            // Declare ViewBags
            List<categorymodel> categories = new List<categorymodel>();
            List<bannermodel> slider = new List<bannermodel>();
            List<productmodel> topProducts = new List<productmodel>();
            List<productmodel> defaultCategoryProducts = new List<productmodel>();

            try
            {
                // Categories
                categories = bl.getallowcategories();

                // Default Category
                string defaultCategory = "Fresh Fruits";
                defaultCategoryProducts = bl.GetAdminProductsByCategory(defaultCategory);
                ViewBag.DefaultCategory = defaultCategory;

                // ***** LOAD USER ORDERS *****
                List<OrderListModel> userOrders = bl.GetOrdersByUser(userId);
                ViewBag.UserOrders = userOrders;  // Store in ViewBag
            }
            catch (Exception ex)
            {
                ViewBag.Message = "Error loading profile data: " + ex.Message;
            }


            ViewBag.Slider = slider ?? new List<bannermodel>();
            ViewBag.gettopproduct = topProducts ?? new List<productmodel>();
            ViewBag.Categories = categories ?? new List<categorymodel>();
            ViewBag.DefaultCategoryProducts = defaultCategoryProducts;

            return View(categories);
        }


        public ActionResult userlogin()
        {
            return View();
        }

        public ActionResult userregistration()
        {
            return View();
        }

        public ActionResult Logout()
        {
            Session.Clear();
            Session.Abandon();

            // ✅ Optional: Clear localStorage userId (done in frontend)
            return RedirectToAction("index", "Customer");
        }
    }
}