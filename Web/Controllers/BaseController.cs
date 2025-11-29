using Kaasht_Kart.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Kaasht_Kart.Controllers
{
    public class BaseController : Controller
    {
        Businesslayer bl = new Businesslayer();
        // GET: Base

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            try
            {
                List<categorymodel> categoriesallow = new List<categorymodel>();
                List<categorymodel> getallcategories = new List<categorymodel>();

                categoriesallow = bl.getallowcategories();
                getallcategories = bl.GetCategories();
                ViewBag.Categories = categoriesallow ?? new List<categorymodel>();
                ViewBag.getallcategories = getallcategories ?? new List<categorymodel>();
            }
            catch   
            {
                ViewBag.Categories = new List<categorymodel>();
            }

            base.OnActionExecuting(filterContext);
        }
    }
}