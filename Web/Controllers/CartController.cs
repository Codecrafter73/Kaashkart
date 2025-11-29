using Kaasht_Kart.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Kaasht_Kart.Controllers
{
    public class CartController : Controller
    {
        Businesslayer bl = new Businesslayer();

        public ActionResult Checkout()
        {
            if (Session["UserId"] == null)
                return RedirectToAction("Login", "Account");

            var cart = Session["Cart"] as List<CartItemModel>;

            if (cart == null || cart.Count == 0)
                return RedirectToAction("Cart");

            int userId = Convert.ToInt32(Session["UserId"]);
            ViewBag.User = userId;
            return View(cart);
        }


    }
}