using Kaasht_Kart.Models;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Mvc;
using HttpGetAttribute = System.Web.Http.HttpGetAttribute;
using RouteAttribute = System.Web.Http.RouteAttribute;

namespace Kaasht_Kart.ApiControllers
{
    public class userapiController : ApiController
    {
        Businesslayer bl = new Businesslayer();

        [HttpGet]
        [Route("api/user/getcategory")] // ✅ Full route define
        public IHttpActionResult GetCategory()
        {
            try
            {
                var categories = bl.getallowcategories();
                return Ok(new { success = true, data = categories });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = ex.Message });
            }
        }


        [System.Web.Http.HttpGet]
        [Route("api/user/getproduct")]
        public IHttpActionResult GettopProducts()
        {
            try
            {
                // Call Business Layer method
                List<productmodel> products = bl.GetAllProducts();

                if (products == null || products.Count == 0)
                {
                    return Ok(new { success = false, message = "No products found." });
                }

                return Ok(new
                {
                    success = true,
                    totalRecords = products.Count,
                 
                    data = products
                });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = ex.Message });
            }
        }

        // ✅ Get Single Product Details by ID
        [System.Web.Http.HttpGet]
        [Route("api/user/getproductdetails")]
        public IHttpActionResult GetProductDetails(int productId)
        {
            try
            {
                var product = bl.GetProductDetails(productId);

                if (product == null)
                    return Ok(new { success = false, message = "Product not found" });

                return Ok(new { success = true, data = product });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = ex.Message });
            }
        }


        //[HttpGet]
        //[Route("api/user/getbycategory")]
        //public IHttpActionResult getbycategory(string categoryname)
        //{
            //try
            //{
            //    if (string.IsNullOrEmpty(categoryname))
            //    {
            //        return Ok(new { success = false, message = "Category name is required." });
            //    }

            //    var products = bl.GetCategoryProducts(categoryname);

            //    if (products != null)
            //    {
            //        return Ok(new { success = true, data = products });
            //    }
            //    else
            //    {
            //        return Ok(new { success = false, message = "No products found for this category." });
            //    }
            //}
            //catch (Exception ex)
            //{
            //    return Ok(new { success = false, message = "Error: " + ex.Message });
            //}
        //}

    }
}
