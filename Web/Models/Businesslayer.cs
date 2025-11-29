using Microsoft.AspNetCore.Hosting.Server;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace Kaasht_Kart.Models
{
    public class Businesslayer
    {
        DataLayer dl = new DataLayer();
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connection"].ConnectionString);

        public string AddCategory(categorymodel model)
        {
            string fileName = "";
            try
            {
                // ✅ Create folder path
                string folderPath = HttpContext.Current.Server.MapPath("~/Content/AdminFile/Products/Categoryimage");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                // ✅ Save image if exists
                if (model.categoryimage != null && model.categoryimage.ContentLength > 0)
                {
                    string ext = Path.GetExtension(model.categoryimage.FileName);
                    string random = new Random().Next(100, 999).ToString();
                    fileName = "category_" + DateTime.Now.ToString("yyyyMMdd") + "_" + random + ext;

                    string savePath = Path.Combine(folderPath, fileName);
                    model.categoryimage.SaveAs(savePath);
                }

                SqlCommand cmd = new SqlCommand("sp_manage_categories", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", "ADD");
                cmd.Parameters.AddWithValue("@CategoryName", model.categoryname ?? "");
                cmd.Parameters.AddWithValue("@CategoryImage", fileName); // ✅ pass file name to SP

                conn.Open();
                cmd.ExecuteNonQuery();

                return "Category added successfully";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
            finally
            {
                conn.Close();
            }
        }

        public List<categorymodel> GetCategories()
        {
            List<categorymodel> list = new List<categorymodel>();

            try
            {
                using (SqlCommand cmd = new SqlCommand("sp_manage_categories", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Action", "LIST");

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        foreach (DataRow row in dt.Rows)
                        {
                            list.Add(new categorymodel
                            {
                                categoryid = Convert.ToInt32(row["id"]),
                                categoryname = row["category_name"].ToString(),
                                categorystatus = row["categorystatus"] != DBNull.Value && Convert.ToBoolean(row["categorystatus"]),
                                categoryimagepath = row["categoryimage"] != DBNull.Value ? row["categoryimage"].ToString() : ""

                            });
                        }
                    }
                }
            }
            catch (Exception)
            {
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                    conn.Close();
            }

            return list;
        }

        public int UpdateCategoryStatus(int id, bool status)
        {
            try
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE tbl_categories SET categorystatus=@status WHERE id=@id", conn))
                {
                    cmd.Parameters.AddWithValue("@status", status);
                    cmd.Parameters.AddWithValue("@id", id);

                    conn.Open();
                    int result = cmd.ExecuteNonQuery();
                    conn.Close();

                    return result; // returns 1 if success
                }
            }
            catch
            {
                if (conn.State == ConnectionState.Open)
                    conn.Close();
                return 0;
            }
        }

        public List<categorymodel> getallowcategories()
        {
            List<categorymodel> list = new List<categorymodel>();

            try
            {
                using (SqlCommand cmd = new SqlCommand("sp_getallowcategory", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;


                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        foreach (DataRow row in dt.Rows)
                        {
                            list.Add(new categorymodel
                            {
                                categoryid = Convert.ToInt32(row["id"]),
                                categoryname = row["category_name"].ToString(),
                                categoryimagepath = row["categoryimage"].ToString(),

                            });
                        }
                    }
                }
            }
            catch (Exception)
            {
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                    conn.Close();
            }

            return list;
        }

        [HttpPost]

        public string AddProduct(productmodel model)
        {
            string mainImageName = "";
            string subImagesNames = "";
            string message = "";

            try
            {
                string mainFolder = HttpContext.Current.Server.MapPath("~/Content/AdminFile/Products/mainimages/");
                string subFolder = HttpContext.Current.Server.MapPath("~/Content/AdminFile/Products/submainimages/");

                if (!Directory.Exists(mainFolder)) Directory.CreateDirectory(mainFolder);
                if (!Directory.Exists(subFolder)) Directory.CreateDirectory(subFolder);

                string cleanCategoryName = Regex.Replace(model.CategoryName ?? "Category", @"[^a-zA-Z0-9]", "_");

                // Save main image
                if (model.ProductImage != null && model.ProductImage.ContentLength > 0)
                {
                    string ext = Path.GetExtension(model.ProductImage.FileName);
                    mainImageName = $"{cleanCategoryName}_main_{DateTime.Now:yyyyMMddHHmmss}{ext}";
                    model.ProductImage.SaveAs(Path.Combine(mainFolder, mainImageName));
                }

                // Save sub images
                if (model.ProductSubImageUpload != null)
                {
                    List<string> list = new List<string>();
                    int i = 1;

                    foreach (var file in model.ProductSubImageUpload)
                    {
                        if (file != null && file.ContentLength > 0)
                        {
                            string ext = Path.GetExtension(file.FileName);
                            string name = $"{cleanCategoryName}_sub_{DateTime.Now:yyyyMMddHHmmss}_{i}{ext}";
                            file.SaveAs(Path.Combine(subFolder, name));
                            list.Add(name);
                            i++;
                        }
                    }

                    subImagesNames = string.Join(",", list);
                }

                // Convert lists to strings
                string unitQuantity = model.UnitQuantity != null ? string.Join(",", model.UnitQuantity) : "";
                string unit = model.Unit != null ? string.Join(",", model.Unit) : "";
                string price = model.Price != null ? string.Join(",", model.Price) : "";
                string discount = model.Discount != null ? string.Join(",", model.Discount) : "";
                string finalPrice = model.FinalPrice != null ? string.Join(",", model.FinalPrice) : "";
                string stock = model.Stock_Quantity != null ? string.Join(",", model.Stock_Quantity) : "";

                // Insert into DB
                using (SqlCommand cmd = new SqlCommand("sp_insert_product", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ProductName", model.ProductName ?? "");
                    cmd.Parameters.AddWithValue("@Categoryname", model.CategoryName ?? "");

                    // Price related (convert lists → comma-separated string)
                    cmd.Parameters.AddWithValue("@BasePrice", price);  //   ✔ CORRECT
                    cmd.Parameters.AddWithValue("@DiscountPercent", discount);  // ✔ CORRECT
                    cmd.Parameters.AddWithValue("@FinalPrice", finalPrice);  //  ✔ CORRECT

                    cmd.Parameters.AddWithValue("@Description", model.Description ?? "");
                    cmd.Parameters.AddWithValue("@UsageInfo", model.UsageInfo ?? "");
                    cmd.Parameters.AddWithValue("@Benefits", model.Benefits ?? "");
                    cmd.Parameters.AddWithValue("@StorageInfo", model.StorageInfo ?? "");
                    cmd.Parameters.AddWithValue("@Faq", model.Faq ?? "");

                    cmd.Parameters.AddWithValue("@Stock", stock);
                    cmd.Parameters.AddWithValue("@ProductImage", mainImageName);
                    cmd.Parameters.AddWithValue("@SubImages", subImagesNames);

                    cmd.Parameters.AddWithValue("@UnitQuantity", unitQuantity);
                    cmd.Parameters.AddWithValue("@Unit", unit);
                    cmd.Parameters.AddWithValue("@tagline", model.tagline);

                    if (conn.State != ConnectionState.Open)
                        conn.Open();

                    cmd.ExecuteNonQuery();
                }


                message = "Product added successfully.";
            }
            catch (Exception ex)
            {
                message = "Error adding product: " + ex.Message;
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                    conn.Close();
            }
            return message;
        }



        public List<productmodel> GetAllProducts()
        {
            List<productmodel> products = new List<productmodel>();

            try
            {
                using (SqlCommand cmd = new SqlCommand("sp_get_all_products", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    if (conn.State != ConnectionState.Open)
                        conn.Open();

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);

                        if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                            return products;

                        foreach (DataRow row in ds.Tables[0].Rows)
                        {
                            var product = new productmodel
                            {
                                ProductId = Convert.ToInt32(row["id"]),
                                ProductName = row["product_name"]?.ToString(),
                                CategoryName = row["categoryname"]?.ToString(),
                                tagline = row["tagline"]?.ToString(),
                                Description = row["description"]?.ToString(),
                                UsageInfo = row["usageinfo"]?.ToString(),
                                Benefits = row["benefits"]?.ToString(),
                                StorageInfo = row["storageinfo"]?.ToString(),
                                Faq = row["faq"]?.ToString(),
                                UnitQuantity = row["unitquantity"] != DBNull.Value ? row["unitquantity"].ToString().Split(',').ToList() : new List<string>(),
                                Unit = row["pack"] != DBNull.Value ? row["pack"].ToString().Split(',').ToList() : new List<string>(),
                                Price = row["base_price"] != DBNull.Value ? row["base_price"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                                Discount = row["discount_percent"] != DBNull.Value ? row["discount_percent"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                                FinalPrice = row["final_price"] != DBNull.Value ? row["final_price"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                                Stock_Quantity = row["stock"] != DBNull.Value ? row["stock"].ToString().Split(',').Select(int.Parse).ToList() : new List<int>(),
                                ProductImagePath = row["productimage"]?.ToString(),
                                ProductSubImage = row["productsubimages"] != DBNull.Value
                                    ? row["productsubimages"].ToString().Split(',').Select(i => i.Trim()).ToList()
                                    : new List<string>(),
                                //Status = row["status"]?.ToString(),
                                Created_At = row["created_at"] != DBNull.Value ? Convert.ToDateTime(row["created_at"]) : DateTime.MinValue,
                                Updated_At = row["updated_at"] != DBNull.Value ? Convert.ToDateTime(row["updated_at"]) : DateTime.MinValue
                            };

                            products.Add(product);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error fetching products: {ex.Message}");
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                    conn.Close();
            }

            return products;

        }



        public List<productmodel> GettopProducts()
        {
            List<productmodel> products = new List<productmodel>();


            try
            {
                using (SqlCommand cmd = new SqlCommand("sp_gettopproduct", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    if (conn.State != ConnectionState.Open)
                        conn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        products.Add(new productmodel
                        {
                            ProductId = Convert.ToInt32(row["id"]),
                            ProductName = row["product_name"]?.ToString(),
                            CategoryName = row["categoryname"]?.ToString(),
                            tagline = row["tagline"]?.ToString(),
                            Description = row["description"]?.ToString(),
                            Price = row["base_price"] != DBNull.Value ? row["base_price"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                            Discount = row["discount_percent"] != DBNull.Value ? row["discount_percent"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                            FinalPrice = row["final_price"] != DBNull.Value ? row["final_price"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                            Stock_Quantity = row["stock"] != DBNull.Value ? row["stock"].ToString().Split(',').Select(int.Parse).ToList() : new List<int>(),
                            Unit = row["pack"] != DBNull.Value ? row["pack"].ToString().Split(',').ToList() : new List<string>(),
                            UnitQuantity = row["unitquantity"] != DBNull.Value ? row["unitquantity"].ToString().Split(',').ToList() : new List<string>(),
                            ProductImagePath = row["productimage"]?.ToString(),
                            ProductSubImage = row["productsubimages"] != DBNull.Value
                                ? row["productsubimages"].ToString().Split(',').Select(x => x.Trim()).ToList()
                                : new List<string>(),
                            Created_At = row["created_at"] != DBNull.Value ? Convert.ToDateTime(row["created_at"]) : DateTime.MinValue,
                            Updated_At = row["updated_at"] != DBNull.Value ? Convert.ToDateTime(row["updated_at"]) : DateTime.MinValue
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error fetching top products: {ex.Message}");
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                    conn.Close();
            }

            return products;


        }

        public productmodel GetProductDetails(int productId)
        {
            var p = new productmodel
            {
                ProductSubImage = new List<string>(),
                Unit = new List<string>(),
                UnitQuantity = new List<string>(),
                Price = new List<decimal>(),
                Discount = new List<decimal>(),
                FinalPrice = new List<decimal>(),
                Stock_Quantity = new List<int>()
            };

            try
            {
                using (SqlCommand cmd = new SqlCommand("sp_get_product_details", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ProductId", productId);

                    if (conn.State != ConnectionState.Open)
                        conn.Open();

                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        p.ProductId = Convert.ToInt32(dr["productid"]);
                        p.ProductName = dr["product_name"]?.ToString();
                        p.CategoryName = dr["categoryname"]?.ToString();
                        p.Description = dr["description"]?.ToString();
                        p.UsageInfo = dr["usage_info"]?.ToString();
                        p.Benefits = dr["benefits"]?.ToString();
                        p.StorageInfo = dr["storage_info"]?.ToString();
                        p.Faq = dr["faq"]?.ToString();
                        p.tagline = dr["tagline"]?.ToString();

                        // CSV split fields
                        p.UnitQuantity = dr["unitquantity"] != DBNull.Value
                                        ? dr["unitquantity"].ToString().Split(',').ToList()
                                        : new List<string>();

                        p.Unit = dr["pack"] != DBNull.Value
                                        ? dr["pack"].ToString().Split(',').ToList()
                                        : new List<string>();

                        p.Price = dr["base_price"] != DBNull.Value
                                        ? dr["base_price"].ToString().Split(',').Select(decimal.Parse).ToList()
                                        : new List<decimal>();

                        p.Discount = dr["discount_percent"] != DBNull.Value
                                        ? dr["discount_percent"].ToString().Split(',').Select(decimal.Parse).ToList()
                                        : new List<decimal>();

                        p.FinalPrice = dr["final_price"] != DBNull.Value
                                        ? dr["final_price"].ToString().Split(',').Select(decimal.Parse).ToList()
                                        : new List<decimal>();

                        p.Stock_Quantity = dr["stock"] != DBNull.Value
                                        ? dr["stock"].ToString().Split(',').Select(int.Parse).ToList()
                                        : new List<int>();

                        p.ProductImagePath = dr["productimage"]?.ToString();

                        p.ProductSubImage = dr["productsubimages"] != DBNull.Value
                                            ? dr["productsubimages"].ToString().Split(',').Select(x => x.Trim()).ToList()
                                            : new List<string>();

                        p.Status = dr["status"]?.ToString();
                        p.Created_At = dr["created_at"] != DBNull.Value ? Convert.ToDateTime(dr["created_at"]) : DateTime.MinValue;
                        p.Updated_At = dr["updated_at"] != DBNull.Value ? Convert.ToDateTime(dr["updated_at"]) : DateTime.MinValue;
                    }

                    dr.Close();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching product details: {ex.Message}");
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                    conn.Close();
            }

            return p;
        }




        public string RegisterVendor(vendermodel model)
        {
            try
            {
                string SaveFile(HttpPostedFileBase file, string folder, string prefix)
                {
                    if (file != null && file.ContentLength > 0)
                    {
                        if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                        string ext = Path.GetExtension(file.FileName);
                        string safeName = Regex.Replace(model.LegalEntityName ?? model.BankAccountHolder ?? "Vendor", @"[^A-Za-z0-9_ ]", "").Replace(" ", "_");
                        string fileName = $"{safeName}_{prefix}{ext}";
                        file.SaveAs(Path.Combine(folder, fileName));
                        return fileName;
                    }
                    return "";
                }

                // File uploads
                string registrationCertificate = SaveFile(model.RegistrationCertificate, HttpContext.Current.Server.MapPath("~/Content/VendorDocs/RegistrationCertificates/"), "REGCERT");
                string aadhaarUpload = SaveFile(model.AadhaarUpload, HttpContext.Current.Server.MapPath("~/Content/VendorDocs/Aadhaar/"), "AADHAAR");
                string cancelledCheque = SaveFile(model.CancelledCheque, HttpContext.Current.Server.MapPath("~/Content/VendorDocs/Cheques/"), "CHEQUE");
                string passbookFirstPage = SaveFile(model.PassbookFirstPage, HttpContext.Current.Server.MapPath("~/Content/VendorDocs/Passbooks/"), "PASSBOOK");

                using (SqlCommand cmd = new SqlCommand("sp_VendorFullRegistration", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Action", "INSERT");
                    // Step 1
                    cmd.Parameters.AddWithValue("@VendorType", model.VendorType ?? "");
                    cmd.Parameters.AddWithValue("@LegalName", model.LegalEntityName ?? "");
                    cmd.Parameters.AddWithValue("@BrandName", model.BrandName ?? "");
                    cmd.Parameters.AddWithValue("@RegistrationType", model.RegistrationType ?? "");
                    cmd.Parameters.AddWithValue("@GSTNo", model.GSTNumber ?? "");
                    cmd.Parameters.AddWithValue("@GSTFile", registrationCertificate);
                    cmd.Parameters.AddWithValue("@PANNumber", model.PANNumber ?? "");
                    cmd.Parameters.AddWithValue("@MSMENumber", model.MSMENumber ?? "");
                    cmd.Parameters.AddWithValue("@EstablishmentDate", (object)model.EstablishmentDate ?? DBNull.Value);

                    // Step 2
                    cmd.Parameters.AddWithValue("@AuthFullName", model.AuthFullName ?? "");
                    cmd.Parameters.AddWithValue("@AuthDesignation", model.AuthDesignation ?? "");
                    cmd.Parameters.AddWithValue("@AuthMobile", model.AuthMobile ?? "");
                    cmd.Parameters.AddWithValue("@AuthAltMobile", model.AuthAltMobile ?? "");
                    cmd.Parameters.AddWithValue("@AuthEmail", model.AuthEmail ?? "");
                    cmd.Parameters.AddWithValue("@Password", model.Password ?? "");
                    cmd.Parameters.AddWithValue("@AadhaarNumber", model.AadhaarNumber ?? "");
                    cmd.Parameters.AddWithValue("@AadhaarUpload", aadhaarUpload);

                    // Step 3
                    cmd.Parameters.AddWithValue("@RegisteredAddress", model.RegisteredAddress ?? "");
                    cmd.Parameters.AddWithValue("@WarehouseAddress", model.WarehouseAddress ?? "");
                    cmd.Parameters.AddWithValue("@State", model.State ?? "");
                    cmd.Parameters.AddWithValue("@District", model.District ?? "");
                    cmd.Parameters.AddWithValue("@Pincode", model.Pincode ?? "");
                    cmd.Parameters.AddWithValue("@GoogleMap", model.GoogleMap ?? "");

                    // Step 4
                    cmd.Parameters.AddWithValue("@BankAccountHolder", model.BankAccountHolder ?? "");
                    cmd.Parameters.AddWithValue("@BankName", model.BankName ?? "");
                    cmd.Parameters.AddWithValue("@BranchName", model.BranchName ?? "");
                    cmd.Parameters.AddWithValue("@AccountNumber", model.AccountNumber ?? "");
                    cmd.Parameters.AddWithValue("@IFSC", model.IFSC ?? "");
                    cmd.Parameters.AddWithValue("@CancelledCheque", cancelledCheque);
                    cmd.Parameters.AddWithValue("@PassbookFirstPage", passbookFirstPage);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                return "success";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }



        public List<vendermodel> GetVendorList()
        {
            List<vendermodel> list = new List<vendermodel>();

            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Action", "SELECTALL")
                };

                DataTable dt = dl.ExecuteSelectParamenter("sp_VendorFullRegistration", parameters);

                foreach (DataRow dr in dt.Rows)
                {
                    vendermodel vm = new vendermodel
                    {
                        VendorId = Convert.ToInt32(dr["VendorDbId"]),
                        VendorType = dr["VendorType"].ToString(),
                        LegalEntityName = dr["LegalName"].ToString(),
                        BrandName = dr["BrandName"].ToString(),
                        RegistrationType = dr["RegistrationType"].ToString(),

                        GSTNumber = dr["GSTNo"].ToString(),
                        RegistrationCertificatePath = dr["GSTFile"].ToString(),
                        Password = dr["Password"].ToString(),
                        PANNumber = dr["PANNumber"].ToString(),
                        MSMENumber = dr["MSMENumber"].ToString(),
                        EstablishmentDate = dr["EstablishmentDate"] != DBNull.Value
                                            ? (DateTime?)Convert.ToDateTime(dr["EstablishmentDate"])
                                            : null,
                        AuthFullName = dr["AuthFullName"].ToString(),
                        AuthDesignation = dr["AuthDesignation"].ToString(),
                        AuthMobile = dr["AuthMobile"].ToString(),
                        AuthAltMobile = dr["AuthAltMobile"].ToString(),
                        AuthEmail = dr["AuthEmail"].ToString(),

                        AadhaarNumber = dr["AadhaarNumber"].ToString(),
                        AadhaarUploadPath = dr["AadhaarUpload"].ToString(),

                        RegisteredAddress = dr["RegisteredAddress"].ToString(),
                        WarehouseAddress = dr["WarehouseAddress"].ToString(),
                        State = dr["State"].ToString(),
                        District = dr["District"].ToString(),
                        Pincode = dr["Pincode"].ToString(),
                        GoogleMap = dr["GoogleMap"].ToString(),

                        BankAccountHolder = dr["BankAccountHolder"].ToString(),
                        BankName = dr["BankName"].ToString(),
                        BranchName = dr["BranchName"].ToString(),
                        AccountNumber = dr["AccountNumber"].ToString(),
                        IFSC = dr["IFSC"].ToString(),
                        CancelledChequePath = dr["CancelledCheque"].ToString(),
                        PassbookFirstPagePath = dr["PassbookFirstPage"].ToString(),

                        Status = dr.Table.Columns.Contains("Status")
                                 ? Convert.ToBoolean(dr["Status"])
                                 : false,

                        CreatedDate = dr.Table.Columns.Contains("CreatedDate")
                                      ? dr["CreatedDate"].ToString()
                                      : "",

                        TotalRecords = dr.Table.Columns.Contains("TotalRecords")
                                      ? dr["TotalRecords"].ToString()
                                      : ""
                    };

                    list.Add(vm);
                }
            }
            catch (Exception ex)
            {
                // optionally log error
            }

            return list;
        }


        public int UpdateVendorStatus(int vendorId, bool status)
        {
            SqlParameter[] prms = new SqlParameter[]
            {
                new SqlParameter("@Action", "UPDATE_STATUS"),
                new SqlParameter("@VendorId", vendorId),
                new SqlParameter("@Status", status)
            };

            int result = dl.DML("sp_Vendor", prms);

            if (result > 0 && status == true)
            {
                // Vendor details fetch for sending email
                var vend = GetVendorById(vendorId);
                if (vend != null)
                {
                    SendVendorApprovedEmail(vend.AuthEmail, vend.VendorName, vend.Password);
                }
            }

            return result;
        }

        public vendermodel GetVendorById(int vendorId)
        {
            SqlParameter[] prms = new SqlParameter[]
            {
            new SqlParameter("@Action", "GET_BY_ID"),
            new SqlParameter("@VendorId", vendorId)
            };

            DataTable dt = dl.ExecuteSelectParamenter("sp_Vendor", prms);

            if (dt.Rows.Count > 0)
            {
                return new vendermodel
                {
                    VendorId = Convert.ToInt32(dt.Rows[0]["VendorDbId"]),
                    VendorName = dt.Rows[0]["VendorName"].ToString(),
                    AuthEmail = dt.Rows[0]["Email"].ToString(),
                    Password = dt.Rows[0]["Password"].ToString()
                };
            }

            return null;
        }

        // Email Logic
        private void SendVendorApprovedEmail(string email, string vendorName, string password)
        {
            string loginUrl = "https://localhost:44307/Customer/registration"; // ✅ Change your URL here

            MailMessage mail = new MailMessage();
            mail.To.Add(email);
            mail.From = new MailAddress("accessauthority.business@gmail.com");
            mail.Subject = "🎉 Vendor Account Approved – Welcome to Our Marketplace";

            mail.Body = $@"
                    <div style='font-family:Arial;padding:20px;border:1px solid #ddd;border-radius:8px;'>
                        <h2 style='color:#2d6cdf;'>Welcome {vendorName}! ✅</h2>
                        <p>Congratulations! Your vendor account has been approved successfully.</p>

                        <h3 style='margin-top:20px;'>Your Login Details:</h3>
                        <table style='border-collapse:collapse;'>
                            <tr><td><b>Login Email:</b></td><td> {email}</td></tr>
                            <tr><td><b>Password:</b></td><td>{password}</td></tr>
                        </table>

                        <p style='margin-top:15px;'>Click the button below to login:</p>
        
                        <a href='{loginUrl}' 
                           style='background:#2d6cdf;color:#fff;padding:12px 20px;text-decoration:none;border-radius:5px;display:inline-block;'>
                           Login Now →
                        </a>

                        <hr style='margin-top:20px;' />
                        <p style='font-size:13px;color:#999;'>Regards,<br><b>Your Company Team</b></p>
                    </div>
                    ";

            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.EnableSsl = true;
            smtp.Credentials = new System.Net.NetworkCredential("accessauthority.business@gmail.com", "xcwbzpbzqimnkufd");
            smtp.Send(mail);
        }

        [HttpPost]
        public int AddSlider(bannermodel model)
        {
            // Generate new filename (banner + timestamp)
            string extension = Path.GetExtension(model.imagefile.FileName);
            string newFileName = "banner_" + DateTime.Now.ToString("yyyyMMddHHmmss") + extension;

            // Folder Path
            string folderPath = HttpContext.Current.Server.MapPath("~/Content/Adminfile/Products/Bannerfile/");
            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            // Full Path for Saving File
            string fullPath = Path.Combine(folderPath, newFileName);

            // Save File
            model.imagefile.SaveAs(fullPath);

            // SQL Parameters (Only file name saved)
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@Action", "INSERT"),
                new SqlParameter("@BannerName", model.bannername),
                new SqlParameter("@files", newFileName) // only filename
            };

            int res = dl.DML("sp_Slider", parameters);
            return res;
        }

        public DataTable getallslider()
        {
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@Action","Select"),
            };

            DataTable dt = dl.ExecuteSelectParamenter("sp_Slider", parameters);

            return dt;
        }

        [HttpPost]
        public int UpdateSliderStatus(int sliderId, bool status)
        {
            SqlParameter[] prms = new SqlParameter[]
            {
                new SqlParameter("@Action","UPDATE_STATUS"),
                new SqlParameter("@SliderId", sliderId),
                new SqlParameter("@IsActive", status)
            };

            return dl.DML("sp_Slider", prms);
        }

        public List<bannermodel> getallowslider()
        {
            DataTable dt = dl.ExecuteSelect("sp_getallowslider");
            List<bannermodel> list = new List<bannermodel>();

            foreach (DataRow dr in dt.Rows)
            {
                list.Add(new bannermodel
                {
                    SliderId = Convert.ToInt32(dr["SliderId"]),
                    imagefilepath = dr["files"].ToString(),
                    bannername = dr["ImageName"].ToString(),
                    CreatedDate = dr["CreatedDate"] != DBNull.Value ? Convert.ToDateTime(dr["CreatedDate"]) : DateTime.Now
                });
            }
            return list;
        }



        public DataTable VendorLoginBL(venderlogin login)
        {
            SqlParameter[] para = new SqlParameter[]
            {
                new SqlParameter("@Email", login.loginEmail),
                new SqlParameter("@Password", login.loginPassword)
            };

            return dl.ExecuteSelectParamenter("sp_VendorLogin", para);
        }

        public string SaveVendorProduct(VendorProductModel model, string VenderId)
        {
            string mainImgName = "";
            string subImgNames = "";
            string message = "";

            try
            {
                string mainFolder = HttpContext.Current.Server.MapPath("~/Content/VendorDocs/venderproduct/mainimage/");
                string subFolder = HttpContext.Current.Server.MapPath("~/Content/VendorDocs/venderproduct/subimage/");

                if (!Directory.Exists(mainFolder)) Directory.CreateDirectory(mainFolder);
                if (!Directory.Exists(subFolder)) Directory.CreateDirectory(subFolder);

                // ✅ Clean Vendor & Product
                string vendorId = model.VendorId ?? "Vendor";
                string cleanProduct = Regex.Replace(model.ProductName ?? "Product", @"[^a-zA-Z0-9]", "_");

                // ✅ SAVE MAIN IMAGE
                if (model.ProductImageFile != null)
                {
                    string ext = Path.GetExtension(model.ProductImageFile.FileName);
                    mainImgName = $"{vendorId}_{cleanProduct}_main_{DateTime.Now:yyyyMMddHHmmss}{ext}";
                    string mainPath = Path.Combine(mainFolder, mainImgName);
                    model.ProductImageFile.SaveAs(mainPath);
                }

                // ✅ SAVE MULTIPLE SUB IMAGES

                if (model.productsubimageupload != null && model.productsubimageupload.Count > 0)
                {
                    List<string> files = new List<string>();
                    int index = 1;

                    foreach (var file in model.productsubimageupload)
                    {
                        if (file != null && file.ContentLength > 0)
                        {
                            string ext = Path.GetExtension(file.FileName);
                            string filename = $"{vendorId}_{cleanProduct}_sub_{DateTime.Now:yyyyMMddHHmmss}_{index}{ext}";
                            string subPath = Path.Combine(subFolder, filename);
                            file.SaveAs(subPath);

                            files.Add(filename);
                            index++;
                        }
                    }

                    subImgNames = string.Join(",", files);
                }

                // ✅ DB INSERT CALL
                SqlParameter[] param =
                {
                    new SqlParameter("@Action", "INSERT"),
                    new SqlParameter("@VendorId", VenderId),
                    new SqlParameter("@Categoryname", model.categoryname),
                    new SqlParameter("@ProductName", model.ProductName),
                    new SqlParameter("@Price", model.Price),
                    new SqlParameter("@Discount", model.Discount),
                    //new SqlParameter("@FinalPrice", model.FinalPrice),
                    new SqlParameter("@StockQuantity", model.StockQuantity),
                    new SqlParameter("@UnitValue", model.unitquantity),
                    new SqlParameter("@Unit", model.Unit),
                    new SqlParameter("@Description", model.Description),
                    new SqlParameter("@ProductImage", mainImgName),
                    new SqlParameter("@ProductSubImages", subImgNames)
                };

                int i = dl.DML("SP_VendorProduct_CRUD", param);
                if (i > 0)
                    return "success";
                else
                    return "failed";
            }
            catch (Exception ex)
            {
                message = "❌ Error: " + ex.Message;
            }

            return message;
        }

        public List<VendorProductModel> GetVendorProducts(string vendorId)
        {
            SqlParameter[] param =
            {
                new SqlParameter("@Action", "SELECT"),
                new SqlParameter("@VendorId", vendorId)
            };

            DataTable dt = dl.ExecuteSelectParamenter("SP_VendorProduct_CRUD", param);

            List<VendorProductModel> products = new List<VendorProductModel>();

            foreach (DataRow dr in dt.Rows)
            {
                var product = new VendorProductModel
                {
                    ProductId = Convert.ToInt32(dr["ProductId"]),
                    VendorId = dr["VendorId"].ToString(),
                    categoryname = dr["Categoryname"].ToString(),
                    ProductName = dr["ProductName"].ToString(),
                    Price = Convert.ToDecimal(dr["Price"]),
                    Discount = Convert.ToDecimal(dr["Discount"]),
                    FinalPrice = Convert.ToDecimal(dr["FinalPrice"]),
                    StockQuantity = Convert.ToInt32(dr["StockQuantity"]),
                    unitquantity = dr["UnitValue"].ToString(),
                    Unit = dr["Unit"].ToString(),
                    ProductImage = dr["ProductImage"].ToString(),
                    Description = dr["Description"].ToString(),
                    Status = Convert.ToBoolean(dr["Status"]),
                    productsubimage = new List<string>()  // init list
                };

                // ✅ Split Sub Images column if exists
                if (dt.Columns.Contains("ProductSubImages"))
                {
                    string subImgList = dr["ProductSubImages"].ToString();

                    if (!string.IsNullOrWhiteSpace(subImgList))
                    {
                        var images = subImgList.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                        foreach (var img in images)
                        {
                            product.productsubimage.Add(img.Trim());
                        }
                    }
                }

                products.Add(product);
            }

            return products;
        }

        public VendorProductModel GetVendorProductById(int id)
        {
            SqlParameter[] param =
            {
                new SqlParameter("@Action", "SELECTBYID"),
                new SqlParameter("@ProductId", id)
            };

            DataTable dt = dl.ExecuteSelectParamenter("SP_VendorProduct_CRUD", param);

            VendorProductModel obj = new VendorProductModel();

            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];

                obj.ProductId = Convert.ToInt32(dr["ProductId"]);
                obj.VendorId = dr["VendorId"].ToString();
                obj.categoryname = dr["Categoryname"].ToString();
                obj.ProductName = dr["ProductName"].ToString();
                obj.Price = Convert.ToDecimal(dr["Price"]);
                obj.Discount = Convert.ToDecimal(dr["Discount"]);
                obj.StockQuantity = Convert.ToInt32(dr["StockQuantity"]);
                obj.unitquantity = dr["UnitValue"].ToString();
                obj.Unit = dr["Unit"].ToString();
                obj.ProductImage = dr["ProductImage"].ToString();
                obj.Description = dr["Description"].ToString();

                // ✅ Convert Sub Image string to List
                obj.productsubimage = new List<string>();

                if (dt.Columns.Contains("ProductSubImages"))
                {
                    string subImages = dr["ProductSubImages"].ToString();

                    if (!string.IsNullOrWhiteSpace(subImages))
                    {
                        var imgs = subImages.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var img in imgs)
                        {
                            obj.productsubimage.Add(img.Trim());
                        }
                    }
                }
            }

            return obj;
        }

        //public vendermodel GetVendorDetailsWithProduct(string vendorId)
        //{
        //    vendermodel vm = new vendermodel();
        //    vm.Products = new List<VendorProductModel>();

        //    using (SqlCommand cmd = new SqlCommand("sp_venderdetailswithproduct", conn))
        //    {
        //        cmd.CommandType = CommandType.StoredProcedure;
        //        cmd.Parameters.AddWithValue("@venderid", vendorId);

        //        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
        //        {
        //            DataSet ds = new DataSet();
        //            da.Fill(ds);

        //            // ✅ Table[0] → Vendor detail
        //            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        //            {
        //                DataRow row = ds.Tables[0].Rows[0];

        //                vm.VendorId = Convert.ToInt32(row["VendorDbId"]);
        //                vm.venderuniquedid = row["VendorId"].ToString();
        //                vm.VendorName = row["VendorName"].ToString();
        //                vm.Email = row["Email"].ToString();
        //                vm.Phone = row["Phone"].ToString();
        //                vm.Address = row["Address"].ToString();
        //                vm.GSTNo = row["GSTNo"].ToString();
        //                vm.GSTFilePath = row["GSTFile"].ToString();
        //                vm.CompanyLogoPath = row["CompanyLogo"].ToString();
        //            }

        //            // ✅ Table[1] → Multiple product records
        //            if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
        //            {
        //                foreach (DataRow dr in ds.Tables[1].Rows)
        //                {
        //                    vm.Products.Add(new VendorProductModel
        //                    {
        //                        ProductId = Convert.ToInt32(dr["ProductId"]),
        //                        VendorId = dr["VendorId"].ToString(),
        //                        categoryname = dr["categoryname"].ToString(),
        //                        ProductName = dr["ProductName"].ToString(),
        //                        Price = dr["Price"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["Price"]),
        //                        Discount = dr["Discount"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["Discount"]),
        //                        FinalPrice = dr["FinalPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["FinalPrice"]),
        //                        StockQuantity = dr["StockQuantity"] == DBNull.Value ? 0 : Convert.ToInt32(dr["StockQuantity"]),
        //                        Unit = dr["Unit"].ToString(),
        //                        unitquantity = dr["UnitValue"].ToString(),
        //                        ProductImage = dr["ProductImage"].ToString(),
        //                        Description = dr["Description"].ToString(),
        //                        Status = Convert.ToBoolean(dr["Status"]),
        //                    });
        //                }
        //            }
        //        }
        //    }

        //    return vm;
        //}

        // ✅ Get Admin Products
        public List<productmodel> GetAdminProductsByCategory(string categoryname)
        {
            List<productmodel> adminProducts = new List<productmodel>();


            try
            {
                SqlParameter[] parameters = { new SqlParameter("@categoryname", categoryname) };
                DataTable dt = dl.ExecuteSelectParamenter("sp_getAdminProductsByCategory", parameters);

                foreach (DataRow row in dt.Rows)
                {
                    adminProducts.Add(new productmodel
                    {
                        ProductId = Convert.ToInt32(row["id"]),
                        CategoryName = row["categoryname"]?.ToString(),
                        ProductName = row["product_name"]?.ToString(),
                        Price = row["base_price"] != DBNull.Value ? row["base_price"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                        Discount = row["discount_percent"] != DBNull.Value ? row["discount_percent"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                        FinalPrice = row["final_price"] != DBNull.Value ? row["final_price"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                        UnitQuantity = row["unitquantity"] != DBNull.Value ? row["unitquantity"].ToString().Split(',').ToList() : new List<string>(),
                        Unit = row["pack"] != DBNull.Value ? row["pack"].ToString().Split(',').ToList() : new List<string>(),
                        Stock_Quantity = row["stock"] != DBNull.Value ? row["stock"].ToString().Split(',').Select(int.Parse).ToList() : new List<int>(),
                        ProductImagePath = row["productimage"]?.ToString(),
                        ProductSubImage = row["productsubimages"] != DBNull.Value ? row["productsubimages"].ToString().Split(',').Select(x => x.Trim()).ToList() : new List<string>(),
                        Status = row["status"]?.ToString(),
                        Created_At = row["created_at"] != DBNull.Value ? Convert.ToDateTime(row["created_at"]) : DateTime.MinValue,
                        Updated_At = row["updated_at"] != DBNull.Value ? Convert.ToDateTime(row["updated_at"]) : DateTime.MinValue
                    });
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error fetching admin products by category: {ex.Message}");
            }

            return adminProducts;


        }


        // ✅ Get Vendor Products
        public List<VendorProductModel> GetVendorProductsByCategory(string categoryname)
        {
            List<VendorProductModel> vendorProducts = new List<VendorProductModel>();

            try
            {
                SqlParameter[] parameters = { new SqlParameter("@categoryname", categoryname) };
                DataTable dt = dl.ExecuteSelectParamenter("sp_getVendorProductsByCategory", parameters);

                foreach (DataRow row in dt.Rows)
                {
                    vendorProducts.Add(new VendorProductModel
                    {
                        ProductId = Convert.ToInt32(row["ProductId"]),
                        categoryname = row["categoryname"].ToString(),
                        ProductName = row["ProductName"].ToString(),
                        Price = Convert.ToDecimal(row["Price"]),
                        Discount = Convert.ToDecimal(row["Discount"]),
                        FinalPrice = Convert.ToDecimal(row["FinalPrice"]),
                        ProductImage = row["ProductImage"].ToString(),
                        unitquantity = row["UnitValue"].ToString(),
                        Unit = row["Unit"].ToString()
                    });
                }
            }
            catch (Exception)
            {
                // handle/log error
            }

            return vendorProducts;
        }

        public bool ChangeProductStatus(int id, bool status)
        {
            try
            {
                SqlParameter[] parameters =
                {
                new SqlParameter("@ProductId", id),
                new SqlParameter("@Status", status)
            };

                int rows = dl.DML("sp_ChangeVenderProductStatus", parameters);
                return rows > 0;
            }
            catch (Exception)
            {
                // Log error (optional)
                return false;
            }
        }

        [HttpPost]
        public bool UpdateCategoryDL(int categoryid, string categoryname, string categoryimagepath)
        {
            SqlParameter[] param =
            {
            new SqlParameter("@Action", "Update"),
            new SqlParameter("@CategoryId", categoryid),
            new SqlParameter("@CategoryName", categoryname),
            new SqlParameter("@CategoryImagePath", categoryimagepath)
        };

            int result = dl.DML("sp_CategoryMaster", param);
            return result > 0;
        }

        public int RegisterUser(UserRegistrationModel model)
        {
            SqlParameter[] parameters = {
                new SqlParameter("@Action", "INSERT"),
                new SqlParameter("@UserName", model.UserName ?? (object)DBNull.Value),
                new SqlParameter("@MobileNumber", model.MobileNumber ?? (object)DBNull.Value),
                new SqlParameter("@Gender", model.Gender ?? (object)DBNull.Value),
                new SqlParameter("@Password", model.Password ?? (object)DBNull.Value),
                new SqlParameter("@DateOfBirth",model.DateOfBirth == DateTime.MinValue ? (object)DBNull.Value : model.DateOfBirth),
                new SqlParameter("@Email", model.Email ?? (object)DBNull.Value),
                new SqlParameter("@TermsAccepted", model.TermsAccepted),
                new SqlParameter("@Address", model.Address)
            };

            int rowsAffected = dl.DML("sp_UserRegistration", parameters);
            return rowsAffected;


        }

        public DataTable LoginByEmail(UserRegistrationModel user)
        {
            SqlParameter[] parameters =
            {
                new SqlParameter("@Email", user.Email),
                new SqlParameter("@Password", user.Password),
                new SqlParameter("@Action", "LOGIN"),
            };

            return dl.ExecuteSelectParamenter("sp_UserRegistration", parameters);
        }



        // 🔹 Login using Mobile (Check if number exists)
        public DataTable CheckMobileExists(string mobile)
        {
            SqlParameter[] parameters =
            {
                new SqlParameter("@Action", "CHECKMOBILE"),
                new SqlParameter("@MobileNumber", mobile)
            };

            return dl.ExecuteSelectParamenter("sp_UserRegistration", parameters);
        }


        // 🔹 Verify OTP
        public DataTable VerifyOTP(string mobile, string otp)
        {
            SqlParameter[] parameters =
            {
                new SqlParameter("@Action", "VERIFYOTP"),
                new SqlParameter("@MobileNumber", mobile),
                new SqlParameter("@OTP", otp)
            };

            return dl.ExecuteSelectParamenter("sp_UserRegistration", parameters);
        }


        public productmodel GetProductById(int productId)
        {
            productmodel product = null;


            try
            {
                SqlParameter[] parameters =
                {
        new SqlParameter("@ProductId", productId)
    };

                DataTable dt = dl.ExecuteSelectParamenter("sp_GetProductById", parameters);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];

                    product = new productmodel
                    {
                        ProductId = Convert.ToInt32(row["id"]),
                        ProductName = row["product_name"]?.ToString(),
                        CategoryName = row["categoryname"]?.ToString(),
                        Description = row["description"]?.ToString(),
                        UsageInfo = row["usage_info"]?.ToString(),
                        Benefits = row["benefits"]?.ToString(),
                        StorageInfo = row["storage_info"]?.ToString(),
                        Faq = row["faq"]?.ToString(),
                        Price = row["base_price"] != DBNull.Value ? row["base_price"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                        Discount = row["discount_percent"] != DBNull.Value ? row["discount_percent"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                        FinalPrice = row["final_price"] != DBNull.Value ? row["final_price"].ToString().Split(',').Select(decimal.Parse).ToList() : new List<decimal>(),
                        UnitQuantity = row["unitquantity"] != DBNull.Value ? row["unitquantity"].ToString().Split(',').ToList() : new List<string>(),
                        Unit = row["pack"] != DBNull.Value ? row["pack"].ToString().Split(',').ToList() : new List<string>(),
                        Stock_Quantity = row["stock"] != DBNull.Value ? row["stock"].ToString().Split(',').Select(int.Parse).ToList() : new List<int>(),
                        ProductImagePath = row["productimage"]?.ToString(),
                        ProductSubImage = row["productsubimages"] != DBNull.Value ? row["productsubimages"].ToString().Split(',').Select(x => x.Trim()).ToList() : new List<string>(),
                        Status = row["status"]?.ToString(),
                        Created_At = row["created_at"] != DBNull.Value ? Convert.ToDateTime(row["created_at"]) : DateTime.MinValue,
                        Updated_At = row["updated_at"] != DBNull.Value ? Convert.ToDateTime(row["updated_at"]) : DateTime.MinValue
                    };
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error fetching product by ID: {ex.Message}");
            }

            return product;


        }



        public int SaveOrder(Order order, List<CartItemModel> items)
        {
            int orderId = 0;

            conn.Open();
            SqlTransaction transaction = conn.BeginTransaction();

            try
            {
                // STEP 1: SAVE ORDER
                using (SqlCommand cmd = new SqlCommand("usp_SaveOrder", conn, transaction))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@UserId", order.UserId);
                    cmd.Parameters.AddWithValue("@UserName", order.CustomerName ?? "");
                    cmd.Parameters.AddWithValue("@Mobile", order.Mobile ?? "");
                    cmd.Parameters.AddWithValue("@Email", order.Email ?? "");
                    cmd.Parameters.AddWithValue("@Address", order.Address ?? "");
                    cmd.Parameters.AddWithValue("@GrandTotal", order.TotalAmount);
                    cmd.Parameters.AddWithValue("@PaymentMethod", order.PaymentMethod ?? "COD");
                    cmd.Parameters.AddWithValue("@PaymentStatus", order.PaymentStatus ?? "Pending");

                    SqlParameter outParam = new SqlParameter("@OrderId", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    cmd.ExecuteNonQuery();
                    orderId = Convert.ToInt32(outParam.Value);
                }



                // STEP 2: SAVE ORDER ITEMS
                foreach (var item in items)
                {
                    string finalImageName = "";

                    // SAVE IMAGE IN FOLDER
                    if (!string.IsNullOrEmpty(item.Image))
                    {
                        try
                        {
                            // Generate unique file name
                            finalImageName = $"Order_{orderId}_{item.Id}_{DateTime.Now.Ticks}.jpg";

                            string folderPath = HttpContext.Current.Server.MapPath("~/Content/Kaasht-Kart/OrderImages/");
                            if (!Directory.Exists(folderPath))
                                Directory.CreateDirectory(folderPath);

                            string fullPath = Path.Combine(folderPath, finalImageName);

                            // Base64 string handling
                            string base64Data = item.Image.Contains(",")
                                                ? item.Image.Split(',')[1]
                                                : item.Image;

                            byte[] imageBytes = Convert.FromBase64String(base64Data);
                            File.WriteAllBytes(fullPath, imageBytes);
                        }
                        catch
                        {
                            finalImageName = "";  // If image fails, save blank
                        }
                    }


                    // SAVE DB ROW
                    using (SqlCommand cmd2 = new SqlCommand("usp_SaveOrderItem", conn, transaction))
                    {
                        cmd2.CommandType = CommandType.StoredProcedure;

                        cmd2.Parameters.AddWithValue("@OrderId", orderId);
                        cmd2.Parameters.AddWithValue("@ProductId", item.Id);
                        cmd2.Parameters.AddWithValue("@ProductName", item.Name);
                        cmd2.Parameters.AddWithValue("@ImageUrl", finalImageName);
                        cmd2.Parameters.AddWithValue("@Price", item.Price);
                        cmd2.Parameters.AddWithValue("@Qty", item.Qty);
                        cmd2.Parameters.AddWithValue("@Total", item.Total);

                        cmd2.ExecuteNonQuery();
                    }
                }


                // SUCCESS → COMMIT TRANSACTION
                transaction.Commit();
            }
            catch (Exception)
            {
                transaction.Rollback();
                throw;
            }
            finally
            {
                conn.Close();
            }

            return orderId;
        }

        public List<OrderListModel> GetOrdersByUser(int userId)
        {
            SqlParameter[] param =
            {
        new SqlParameter("@UserId", userId)
    };

            DataSet ds = dl.ExecuteSelectDataSet("usp_GetOrdersByUser", param);

            var orderList = new List<OrderListModel>();
            var orderLookup = new Dictionary<int, OrderListModel>();

            //-------------------------------------------
            // TABLE 0 : ORDER HEADER (Username removed)
            //-------------------------------------------
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                var order = new OrderListModel
                {
                    OrderId = Convert.ToInt32(row["OrderId"]),
                    GrandTotal = Convert.ToDecimal(row["GrandTotal"]),
                    OrderStatus = row["OrderStatus"]?.ToString(),
                    OrderDate = Convert.ToDateTime(row["OrderDate"]),
                    Items = new List<OrderItemModel>()
                };

                orderList.Add(order);
                orderLookup[order.OrderId] = order;
            }

            //-------------------------------------------
            // TABLE 1 : ORDER ITEMS
            //-------------------------------------------
            foreach (DataRow row in ds.Tables[1].Rows)
            {
                int orderId = Convert.ToInt32(row["OrderId"]);

                if (orderLookup.ContainsKey(orderId))
                {
                    orderLookup[orderId].Items.Add(new OrderItemModel
                    {
                        ProductName = row["ProductName"]?.ToString(),
                        ProductImageUrl = row["ProductImageUrl"] == DBNull.Value ? "" : row["ProductImageUrl"].ToString(),
                        Qty = Convert.ToInt32(row["Qty"]),
                        Price = Convert.ToDecimal(row["Price"]),
                        Total = Convert.ToDecimal(row["Total"])
                    });
                }
            }

            return orderList;
        }





        public void SendOrderSuccessSMS(string mobile, int orderId)
        {
            string msg = $"Your order #{orderId} has been successfully placed. Thank you for shopping with us.";

            // Use any SMS API (Fast2SMS, Twilio, MSG91 etc.)
        }


    }
}