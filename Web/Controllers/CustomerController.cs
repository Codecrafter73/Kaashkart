using Kaasht_Kart.Models;
using Microsoft.Extensions.Logging.Abstractions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing.Printing;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace Kaasht_Kart.Controllers
{
    [AuthFilter]
    public class CustomerController : BaseController
    {

        Businesslayer bl = new Businesslayer();
        // GET: Customer
        public ActionResult Index()
        {
            List<categorymodel> categoriesallow = new List<categorymodel>();
            List<categorymodel> getallcategories = new List<categorymodel>();
            List<bannermodel> slider = new List<bannermodel>();
            List<productmodel> topProducts = new List<productmodel>();
            List<productmodel> defaultCategoryProducts = new List<productmodel>();

            try
            {
                categoriesallow = bl.getallowcategories();
                getallcategories = bl.GetCategories();
                slider = bl.getallowslider();
                topProducts = bl.GettopProducts();

                // ✅ Default category: "Fresh Fruits"
                string defaultCategory = "Fresh Fruits";
                defaultCategoryProducts = bl.GetAdminProductsByCategory(defaultCategory);
                ViewBag.DefaultCategory = defaultCategory;
            }
            catch (Exception ex)
            {
                ViewBag.Message = "⚠️ Error loading homepage data: " + ex.Message;
            }

            ViewBag.Slider = slider ?? new List<bannermodel>();
            ViewBag.gettopproduct = topProducts ?? new List<productmodel>();
            ViewBag.Categories = categoriesallow ?? new List<categorymodel>();
            ViewBag.getallcategories = getallcategories ?? new List<categorymodel>();

            // ✅ Send default products to partial view
            ViewBag.DefaultCategoryProducts = defaultCategoryProducts;

            return View(categoriesallow);
        }

        public PartialViewResult ProductListPartial(string categoryname)
        {
            var products = bl.GetAdminProductsByCategory(categoryname);
            return PartialView("_ProductListPartial", products);
        }


        [HttpGet]


        public ActionResult about()
        {
            return View();
        }

        public ActionResult contact()
        {
            return View();
        }

        public ActionResult productdetails(int id)
        {
            if (id > 0)
            {

                var product = bl.GetProductDetails(id);
                return View(product);
            }
            else
            {
                return RedirectToAction("Index");
            }
        }
        public ActionResult registration()
        {
            return View();
        }

        [HttpPost]
        public ActionResult RegisterVendor(vendermodel model)
        {
            string result = bl.RegisterVendor(model);

            if (result == "success")
                return Json(new { status = true, message = "Vendor Registered Successfully ✅" });

            return Json(new { status = false, message = result });
        }

        public ActionResult GetCategoryWiseProductDetails(string categoryname)
        {
            var adminProducts = bl.GetAdminProductsByCategory(categoryname);
            var vendorProducts = bl.GetVendorProductsByCategory(categoryname);

            var vm = new CategoryWiseProductsViewModel
            {
                AdminProducts = adminProducts,
                VendorProducts = vendorProducts,
                CategoryName = categoryname
            };

            return View(vm);
        }


        public ActionResult Cart()
        {
            var cart = Session["Cart"] as List<CartItemModel> ?? new List<CartItemModel>();
            return View(cart);
        }


        [HttpPost]
        public ActionResult AddToCart(int productId, int qty = 1)
        {
            var cart = Session["Cart"] as List<CartItemModel>;
            if (cart == null)
                cart = new List<CartItemModel>();


            var product = bl.GetProductById(productId);
            if (product == null)
                return Json(new { success = false });

            var existingItem = cart.FirstOrDefault(x => x.Id == productId);
            decimal price = product.Price != null && product.Price.Count > 0 ? product.Price[0] : 0;

            if (existingItem != null)
            {
                existingItem.Qty += qty;
            }
            else
            {
                cart.Add(new CartItemModel
                {
                    Id = product.ProductId,
                    Name = product.ProductName,
                    Price = price,
                    Qty = qty,
                    Image = product.ProductImagePath
                });
            }

            Session["Cart"] = cart;

            return Json(new { success = true });

}



        public JsonResult CheckUserLoginStatus()
        {
            bool isLoggedIn = false;
            //string userName = "";

            // ✅ Check session from any controller
            if (System.Web.HttpContext.Current.Session["UserId"] != null)
            {
                isLoggedIn = true;
                //userName = System.Web.HttpContext.Current.Session["UserName"].ToString();
            }

            return Json(new { isLoggedIn = isLoggedIn }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Checkout()
        {
            // Check if user is logged in
            if (Session["UserId"] == null)
                return RedirectToAction("userlogin", "Account");

            // Get cart from session
            var cart = Session["Cart"] as List<CartItemModel>;

            // Redirect to Cart page if cart is empty or null
            if (cart == null || !cart.Any())
            {
                TempData["Message"] = "Your cart is empty!";
                return RedirectToAction("Cart");
            }

            // Create CheckoutViewModel and populate user and cart details
            var model = new CheckoutViewModel
            {
                UserName = Session["UserName"]?.ToString(),
                Mobile = Session["MobileNumber"]?.ToString(),
                Address = Session["Address"]?.ToString(),
                Email = Session["Email"]?.ToString(),
                CartItems = cart,
                GrandTotal = cart.Sum(x => x.Price * x.Qty)
            };

            return View(model);
        }


        public ActionResult Login()
        {
            return View();
        }


        [HttpPost]
        public ActionResult Login(venderlogin login)
        {
            if (string.IsNullOrEmpty(login.loginEmail) || string.IsNullOrEmpty(login.loginPassword))
            {
                ViewBag.Msg = "Email & Password required ❗";
                return View();
            }

            DataTable dt = bl.VendorLoginBL(login);

            if (dt.Rows.Count > 0)
            {
                // Login success
                Session["VendorId"] = dt.Rows[0]["VendorId"];
                Session["VendorName"] = dt.Rows[0]["VendorName"];
                Session["VendorEmail"] = dt.Rows[0]["Email"];

                return RedirectToAction("venderdashbaord", "Vender");
            }
            else
            {
                ViewBag.Msg = "Your account is not approved OR invalid login ❌";
                return View("/Customer/registration");
            }
        }



        [HttpPost]
        public JsonResult Register(UserRegistrationModel model)
        {
            if (model != null)
            {
                int registrationResult = bl.RegisterUser(model); // business layer call

                if (registrationResult > 0)
                {
                    return Json(new { success = true, message = "Registration Successful!" });
                }
                else
                {
                    return Json(new { success = false, message = "Registration failed. Try again." });
                }
            }

            return Json(new { success = false, message = "Invalid input data." });
        }

        public ActionResult OrderSuccess(int id)
        {
            ViewBag.OrderId = id;
            return View();
        }



        [HttpPost]
        public JsonResult SaveOrder(string paymentMethod)
        {
            try
            {
                if (Session["UserId"] == null)
                {
                    return Json(new { status = "error", message = "User not logged in" });
                }

                List<CartItemModel> cart = Session["Cart"] as List<CartItemModel>;

                if (cart == null || cart.Count == 0)
                {
                    return Json(new { status = "error", message = "Cart is empty" });
                }

                // Prepare Order Model
                Order order = new Order
                {
                    UserId = Convert.ToInt32(Session["UserId"]),
                    CustomerName = Session["UserName"]?.ToString(),
                    Mobile = Session["MobileNumber"]?.ToString(),
                    Email = Session["Email"]?.ToString(),
                    Address = Session["Address"]?.ToString(),
                    TotalAmount = cart.Sum(x => x.Price * x.Qty),
                    PaymentMethod = paymentMethod,
                    PaymentStatus = "Pending"
                };


                // ***** IMPORTANT: PASS TWO PARAMETERS *****
                int orderId = bl.SaveOrder(order, cart);

                // Clear cart after success
                Session["Cart"] = null;

                return Json(new { status = "success", orderId = orderId });
            }
            catch (Exception ex)
            {
                return Json(new { status = "error", message = ex.Message });
            }
        }

        public ActionResult Payment()
        {
            // User not logged in → redirect
            if (Session["UserId"] == null)
            {
                return RedirectToAction("userlogin", "Account");
            }

            // User details (optional)
            UserModel user = new UserModel
            {
                UserId = Convert.ToInt32(Session["UserId"]),
                UserName = Session["UserName"]?.ToString(),
                MobileNumber = Session["Mobile"]?.ToString(),
                Email = Session["Email"]?.ToString(),
                Address = Session["Address"]?.ToString()
            };

            return View(user);
        }










    }
}