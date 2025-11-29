using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Kaasht_Kart.Models
{
    public class vendermodel
    {
        public int VendorId { get; set; }
        public int VendorDbId { get; set; }

        // STEP 1: Vendor / Organization Details
        public string VendorType { get; set; }
        public string VendorName { get; set; }
        public string LegalEntityName { get; set; }
        public string BrandName { get; set; }
        public string RegistrationType { get; set; }

        public HttpPostedFileBase RegistrationCertificate { get; set; }
        public string RegistrationCertificatePath { get; set; }

        public DateTime? EstablishmentDate { get; set; }
        public string GSTStatus { get; set; }
        public string GSTNumber { get; set; }
        public string PANNumber { get; set; }
        public string MSMENumber { get; set; }

        // STEP 2: Authorized Person Details
        public string AuthFullName { get; set; }
        public string AuthDesignation { get; set; }
        public string AuthMobile { get; set; }
        public string AuthAltMobile { get; set; }
        public string AuthEmail { get; set; }
        public string Password { get; set; }
        public string AadhaarNumber { get; set; }

        public HttpPostedFileBase AadhaarUpload { get; set; }
        public string AadhaarUploadPath { get; set; }

        // STEP 3: Address Details
        public string RegisteredAddress { get; set; }
        public string WarehouseAddress { get; set; }
        public string State { get; set; }
        public string District { get; set; }
        public string Pincode { get; set; }
        public string GoogleMap { get; set; }

        // STEP 4: Bank Details
        public string BankAccountHolder { get; set; }
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public string AccountNumber { get; set; }
        public string IFSC { get; set; }

        public HttpPostedFileBase CancelledCheque { get; set; }
        public string CancelledChequePath { get; set; }

        public HttpPostedFileBase PassbookFirstPage { get; set; }
        public string PassbookFirstPagePath { get; set; }
        public string TotalRecords { get; set; }

        // Default columns
        public bool Status { get; set; }
        public string CreatedDate { get; set; }
    }

}