//using Microsoft.AspNetCore.Cors;
//using System.Web.Http;

using System.Web.Http;
using System.Web.Http.Cors;

namespace Kaasht_Kart
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Fix: Correctly configure EnableCorsAttribute with origins, headers, and methods
            var cors = new EnableCorsAttribute("*", "*", "*");
            config.EnableCors(cors);

            // ✅ Remove XML formatter (only return JSON)
            config.Formatters.Remove(config.Formatters.XmlFormatter);

            // ✅ Enable Attribute Routing
            config.MapHttpAttributeRoutes();

            // ✅ Default route (for fallback)
            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{action}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }
    }
}
