using Kaasht_Kart.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Kaasht_Kart.ApiControllers
{
    public class venderapiController : ApiController
    {
        Businesslayer bl = new Businesslayer();

        // ✅ GET: api/vendor/list?pageNo=1&pageSize=10
        [HttpGet]
        [Route("api/venderapi/getvendorproductlist")]
        public IHttpActionResult getvendorproductlist()
        {
            try
            {
                var vendors = bl.GetVendorList();

                if (vendors == null || vendors.Count == 0)
                    return NotFound();

                return Ok(new
                {
                    success = true,
                    totalRecords = vendors.First().TotalRecords,
                    data = vendors
                });
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }
    }
}
