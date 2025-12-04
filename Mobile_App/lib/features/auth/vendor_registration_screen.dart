import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/custom_buttons_utils.dart';
import 'package:kaashtkart/core/utls/custom_text_field_utils.dart';
import 'package:kaashtkart/core/utls/responsive_dropdown_utils.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';

class VendorRegistrationFormScreen extends StatefulWidget {
  const VendorRegistrationFormScreen({super.key});

  @override
  State<VendorRegistrationFormScreen> createState() =>
      _VendorRegistrationFormScreenState();
}

class _VendorRegistrationFormScreenState
    extends State<VendorRegistrationFormScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 7;

  // Form Keys for validation
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    7,
    (index) => GlobalKey<FormState>(),
  );

  // Step 1: Vendor Details Controllers
  final TextEditingController _vendorTypeController = TextEditingController();
  final TextEditingController _legalEntityNameController =
      TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _registrationTypeController =
      TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _establishmentDateController =
      TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();
  final TextEditingController _msmeNumberController = TextEditingController();
  bool _hasGST = false;

  // Step 2: Authorized Person Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _alternateMobileController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();

  // Step 3: Address Controllers
  final TextEditingController _registeredAddressController =
      TextEditingController();
  final TextEditingController _warehouseAddressController =
      TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _mapLocationController = TextEditingController();

  // Step 4: Bank Details Controllers
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();

  // Step 5: Product Category Controllers
  // final TextEditingController _productCategoryController = TextEditingController();
  // final TextEditingController _productNameController = TextEditingController();
  // final TextEditingController _productDescriptionController = TextEditingController();
  // final TextEditingController _packagingTypeController = TextEditingController();
  // final TextEditingController _variantsController = TextEditingController();
  // final TextEditingController _stockQuantityController = TextEditingController();
  // final TextEditingController _mrpController = TextEditingController();
  // final TextEditingController _vendorPriceController = TextEditingController();

  // Step 6: Compliance & Certifications Controllers
  final TextEditingController _fssaiController = TextEditingController();
  final TextEditingController _organicCertController = TextEditingController();
  final TextEditingController _agmarkController = TextEditingController();
  final TextEditingController _tradeLicenseController = TextEditingController();

  // Step 7: Logistics Controllers
  final TextEditingController _productionCapacityController =
      TextEditingController();
  final TextEditingController _minOrderQtyController = TextEditingController();
  final TextEditingController _shippingMethodController =
      TextEditingController();
  final TextEditingController _dispatchTATController = TextEditingController();
  bool _hasBulkSupply = false;
  String _packagingCapability = 'Own';

  // Step 8: Agreement Controllers
  bool _commissionAccepted = false;
  bool _paymentSettlementAccepted = false;
  bool _returnPolicyAccepted = false;
  bool _dataComplianceAccepted = false;
  final TextEditingController _signatureController = TextEditingController();

  // Step 9: Additional Info Controllers
  final TextEditingController _pastBuyersController = TextEditingController();
  final TextEditingController _specialFacilitiesController =
      TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose all controllers
    _vendorTypeController.dispose();
    _legalEntityNameController.dispose();
    _brandNameController.dispose();
    _registrationTypeController.dispose();
    _registrationNumberController.dispose();
    _establishmentDateController.dispose();
    _gstNumberController.dispose();
    _panNumberController.dispose();
    _msmeNumberController.dispose();
    _fullNameController.dispose();
    _designationController.dispose();
    _mobileController.dispose();
    _alternateMobileController.dispose();
    _emailController.dispose();
    _aadhaarController.dispose();
    _registeredAddressController.dispose();
    _warehouseAddressController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    _mapLocationController.dispose();
    _accountHolderController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    // _productCategoryController.dispose();
    // _productNameController.dispose();
    // _productDescriptionController.dispose();
    // _packagingTypeController.dispose();
    // _variantsController.dispose();
    // _stockQuantityController.dispose();
    // _mrpController.dispose();
    // _vendorPriceController.dispose();
    _fssaiController.dispose();
    _organicCertController.dispose();
    _agmarkController.dispose();
    _tradeLicenseController.dispose();
    _productionCapacityController.dispose();
    _minOrderQtyController.dispose();
    _shippingMethodController.dispose();
    _dispatchTATController.dispose();
    _signatureController.dispose();
    _pastBuyersController.dispose();
    _specialFacilitiesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitForm() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor Registration Submitted Successfully!'),
        ),
      );
    }
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Vendor Details';
      case 1:
        return 'Authorized Person';
      case 2:
        return 'Address Details';
      case 3:
        return 'Bank Details';
      case 4:
        return 'Certifications';
      case 5:
        return 'Logistics';
      case 6:
        return 'Terms & Agreement';
      // case 7: return 'Additional Info';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: Text(
          'Vendor Registration',
          style: AppTextStyles.heading1(context),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
      ),
      body: Column(
        children: [
          // Progress Indicator
          // _buildProgressIndicator(),
          _buildStepIndicator(),
          // Step Title
          Container(
            padding: ResponsiveHelper.paddingSymmetric(
              context,
              vertical: 12,
              horizontal: 16,
            ),
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Row(
              children: [
                Text(
                  'Step ${_currentStep + 1} of $_totalSteps: ',
                  style: AppTextStyles.body1(
                    context,
                    overrideStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
                      ),
                    ),
                  ),
                ),
                // Text(
                //   _getStepTitle(_currentStep),
                //   style: AppTextStyles.heading2(
                //     context,
                //     overrideStyle: const TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1VendorDetails(),
                _buildStep2AuthorizedPerson(),
                _buildStep3AddressDetails(),
                _buildStep4BankDetails(),
                // _buildStep5ProductDetails(),
                _buildStep6Certifications(),
                _buildStep7Logistics(),
                _buildStep8Agreement(),
                _buildStep9AdditionalInfo(),
              ],
            ),
          ),

          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  // Widget _buildProgressIndicator() {
  //   return Container(
  //     padding: ResponsiveHelper.paddingSymmetric(
  //         context, vertical: 16, horizontal: 16),
  //     color: Theme
  //         .of(context)
  //         .brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
  //     child: Row(
  //       children: List.generate(_totalSteps, (index) {
  //         bool isCompleted = index < _currentStep;
  //         bool isCurrent = index == _currentStep;
  //
  //         return Expanded(
  //           child: Container(
  //             margin: ResponsiveHelper.paddingSymmetric(context, horizontal: 2),
  //             height: ResponsiveHelper.containerHeight(context, 4),
  //             decoration: BoxDecoration(
  //               color: isCompleted || isCurrent
  //                   ? AppColors.primary
  //                   : Colors.grey[300],
  //               borderRadius: ResponsiveHelper.borderRadiusAll(context, 2),
  //             ),
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }

  // ←←← YE PURANA PROGRESS BAR WALA FUNCTION DELETE KAR DO ←←←
  // Widget _buildProgressIndicator() { ... }

  Widget _buildStepIndicator() {
    final ScrollController scrollController = ScrollController();

    // Auto-scroll to current step
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          (_currentStep * 140.0).clamp(
            0.0,
            scrollController.position.maxScrollExtent,
          ), // 140 → 140.0
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]
          : Colors.white,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _totalSteps,
        itemBuilder: (context, index) {
          bool isCompleted = index < _currentStep;
          bool isCurrent = index == _currentStep;

          return GestureDetector(
            onTap: () {
              if (index <= _currentStep) {
                setState(() => _currentStep = index);
                _pageController.jumpToPage(index);
              }
            },
            child: Container(
              constraints: const BoxConstraints(minWidth: 130),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isCurrent ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCurrent || isCompleted
                      ? AppColors.primary
                      : Colors.grey[400]!,
                  width: 1.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.endingGreyColor,
                    )
                  else
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: isCurrent
                          ? Colors.white
                          : AppColors.primary,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? AppColors.primary : Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      _getStepTitle(index),
                      style: TextStyle(
                        color: isCurrent
                            ? Colors.white
                            : (isCompleted
                                  ? AppColors.primary
                                  : Colors.grey[700]),
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 13.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: ResponsiveHelper.paddingAll(context, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: CustomButton(
                text: 'Previous',
                onPressed: _previousStep,
                type: ButtonType.outlined,
                borderColor: AppColors.primary,
                textColor: AppColors.primary,
              ),
            ),
          if (_currentStep > 0)
            SizedBox(width: ResponsiveHelper.spacing(context, 12)),
          Expanded(
            flex: _currentStep > 0 ? 1 : 2,
            child: CustomButton(
              text: _currentStep == _totalSteps - 1 ? 'Submit' : 'Next',
              onPressed: _currentStep == _totalSteps - 1
                  ? _submitForm
                  : _nextStep,
              color: AppColors.primary,
              iconData: _currentStep == _totalSteps - 1
                  ? Icons.check_circle
                  : Icons.arrow_forward,
              iconPosition: IconPosition.right,
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Vendor Details
  Widget _buildStep1VendorDetails() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingAll(context, 16),
      child: Form(
        key: _formKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveDropdown<String>(
              value: _vendorTypeController.text.isEmpty
                  ? null
                  : _vendorTypeController.text,
              itemList: const [
                'FPO',
                'SHG',
                'Individual Farmer',
                'MSME',
                'Cooperative',
                'Others',
              ],
              onChanged: (value) {
                if (value != null) _vendorTypeController.text = value;
              },
              hint: 'Select Vendor Type',
              label: 'Vendor Type',
              validator: (value) =>
                  value == null ? 'Please select vendor type' : null,
            ),

            CustomTextField(
              title: 'Legal Entity Name *',
              hintText: 'Enter legal entity name',
              controller: _legalEntityNameController,
              prefixIcon: Icons.corporate_fare,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter legal entity name'
                  : null,
            ),
            CustomTextField(
              title: 'Brand Name',
              hintText: 'Enter brand name (if any)',
              controller: _brandNameController,
              prefixIcon: Icons.branding_watermark,
            ),
            CustomTextField(
              title: 'Registration Type *',
              hintText: 'Enter registration type',
              controller: _registrationTypeController,
              prefixIcon: Icons.assignment,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter registration type'
                  : null,
            ),
            CustomTextField(
              title: 'Registration Number *',
              hintText: 'Enter registration number',
              controller: _registrationNumberController,
              prefixIcon: Icons.confirmation_number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter registration number'
                  : null,
            ),
            CustomTextField(
              title: 'Date of Establishment *',
              hintText: 'Select date',
              controller: _establishmentDateController,
              readOnly: true,
              prefixIcon: Icons.calendar_today,
              onTap: () => _selectDate(_establishmentDateController),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please select date' : null,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 12)),
            Row(
              children: [
                Checkbox(
                  value: _hasGST,
                  onChanged: (value) =>
                      setState(() => _hasGST = value ?? false),
                  activeColor: AppColors.primary,
                ),
                Text('GST Registered', style: AppTextStyles.body1(context)),
              ],
            ),
            if (_hasGST) ...[
              CustomTextField(
                title: 'GST Number *',
                hintText: 'Enter GST number',
                controller: _gstNumberController,
                prefixIcon: Icons.receipt_long,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return newValue.copyWith(text: newValue.text.toUpperCase());
                  }),
                ],
                validator: (value) => _hasGST && (value?.isEmpty ?? true)
                    ? 'Please enter GST number'
                    : null,
              ),
            ],
            CustomTextField(
              title: 'PAN Number *',
              hintText: 'Enter PAN number',
              controller: _panNumberController,
              prefixIcon: Icons.credit_card,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(text: newValue.text.toUpperCase());
                }),
              ],
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter PAN number' : null,
            ),
            CustomTextField(
              title: 'MSME Registration Number',
              hintText: 'Enter MSME number (Optional)',
              controller: _msmeNumberController,
              prefixIcon: Icons.factory,
            ),
          ],
        ),
      ),
    );
  }

  // Step 2: Authorized Person
  Widget _buildStep2AuthorizedPerson() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingAll(context, 16),
      child: Form(
        key: _formKeys[1],
        child: Column(
          children: [
            CustomTextField(
              title: 'Full Name *',
              hintText: 'Enter full name',
              controller: _fullNameController,
              prefixIcon: Icons.person,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter full name' : null,
            ),
            CustomTextField(
              title: 'Designation *',
              hintText: 'Enter designation',
              controller: _designationController,
              prefixIcon: Icons.work,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter designation' : null,
            ),
            CustomTextField(
              title: 'Mobile Number *',
              hintText: 'Enter mobile number',
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter mobile number';
                if (value!.length != 10) {
                  return 'Mobile number must be 10 digits';
                }
                return null;
              },
            ),
            CustomTextField(
              title: 'Alternate Mobile Number',
              hintText: 'Enter alternate mobile',
              controller: _alternateMobileController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_android,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            CustomTextField(
              title: 'Email ID *',
              hintText: 'Enter email address',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter email';
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value!)) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            CustomTextField(
              title: 'Aadhaar Number *',
              hintText: 'Enter Aadhaar number',
              controller: _aadhaarController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.credit_card,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter Aadhaar number';
                }
                if (value!.length != 12) return 'Aadhaar must be 12 digits';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: Address Details
  Widget _buildStep3AddressDetails() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingAll(context, 16),
      child: Form(
        key: _formKeys[2],
        child: Column(
          children: [
            CustomTextField(
              title: 'Registered Address *',
              hintText: 'Enter registered address',
              controller: _registeredAddressController,
              isMultiLine: true,
              maxLines: 4,
              minLines: 4,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter registered address'
                  : null,
            ),
            CustomTextField(
              title: 'Operational / Warehouse Address *',
              hintText: 'Enter warehouse address',
              controller: _warehouseAddressController,
              isMultiLine: true,
              maxLines: 4,
              minLines: 4,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter warehouse address'
                  : null,
            ),
            CustomTextField(
              title: 'State *',
              hintText: 'Select state',
              controller: _stateController,
              prefixIcon: Icons.map,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please select state' : null,
            ),
            CustomTextField(
              title: 'District *',
              hintText: 'Enter district',
              controller: _districtController,
              prefixIcon: Icons.location_city,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter district' : null,
            ),
            CustomTextField(
              title: 'Pincode *',
              hintText: 'Enter pincode',
              controller: _pincodeController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.pin_drop,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter pincode';
                if (value!.length != 6) return 'Pincode must be 6 digits';
                return null;
              },
            ),
            CustomTextField(
              title: 'Google Map Location',
              hintText: 'Enter map location URL (Optional)',
              controller: _mapLocationController,
              prefixIcon: Icons.add_location,
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
    );
  }

  // Step 4: Bank Details
  Widget _buildStep4BankDetails() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingAll(context, 16),
      child: Form(
        key: _formKeys[3],
        child: Column(
          children: [
            CustomTextField(
              title: 'Account Holder Name *',
              hintText: 'Enter account holder name',
              controller: _accountHolderController,
              prefixIcon: Icons.person_outline,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter account holder name'
                  : null,
            ),
            CustomTextField(
              title: 'Bank Name *',
              hintText: 'Enter bank name',
              controller: _bankNameController,
              prefixIcon: Icons.account_balance,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter bank name' : null,
            ),
            CustomTextField(
              title: 'Branch Name *',
              hintText: 'Enter branch name',
              controller: _branchNameController,
              prefixIcon: Icons.location_on,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter branch name' : null,
            ),
            CustomTextField(
              title: 'Account Number *',
              hintText: 'Enter account number',
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.numbers,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter account number' : null,
            ),
            CustomTextField(
              title: 'IFSC Code *',
              hintText: 'Enter IFSC code',
              controller: _ifscController,
              prefixIcon: Icons.code,
              inputFormatters: [
                LengthLimitingTextInputFormatter(11),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(text: newValue.text.toUpperCase());
                }),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter IFSC code';
                if (value!.length != 11) {
                  return 'IFSC code must be 11 characters';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 12)),
            _buildUploadButton('Upload Cancelled Cheque'),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            _buildUploadButton('Upload Passbook First Page'),
          ],
        ),
      ),
    );
  }

  // Step 5: Product Details
  // Widget _buildStep5ProductDetails() {
  //   return SingleChildScrollView(
  //     padding: ResponsiveHelper.paddingAll(context, 16),
  //     child: Form(
  //       key: _formKeys[4],
  //       child: Column(
  //         children: [
  //           CustomTextField(
  //             title: 'Product Categories *',
  //             hintText: 'Select product categories',
  //             controller: _productCategoryController,
  //             prefixIcon: Icons.category,
  //             readOnly: true,
  //             onTap: () => _showProductCategoryDialog(),
  //             validator: (value) =>
  //             value?.isEmpty ?? true
  //                 ? 'Please select product category'
  //                 : null,
  //           ),
  //           CustomTextField(
  //             title: 'Product Name *',
  //             hintText: 'Enter product name',
  //             controller: _productNameController,
  //             prefixIcon: Icons.inventory,
  //             validator: (value) =>
  //             value?.isEmpty ?? true
  //                 ? 'Please enter product name'
  //                 : null,
  //           ),
  //           CustomTextField(
  //             title: 'Product Description *',
  //             hintText: 'Enter product description',
  //             controller: _productDescriptionController,
  //             prefixIcon: Icons.description,
  //             isMultiLine: true,
  //             maxLines: 4,
  //             minLines: 3,
  //             validator: (value) =>
  //             value?.isEmpty ?? true
  //                 ? 'Please enter product description'
  //                 : null,
  //           ),
  //           CustomTextField(
  //             title: 'Packaging Type *',
  //             hintText: 'Enter packaging type',
  //             controller: _packagingTypeController,
  //             prefixIcon: Icons.inventory_2,
  //             validator: (value) =>
  //             value?.isEmpty ?? true
  //                 ? 'Please enter packaging type'
  //                 : null,
  //           ),
  //           CustomTextField(
  //             title: 'Variants',
  //             hintText: 'Enter product variants (Optional)',
  //             controller: _variantsController,
  //             prefixIcon: Icons.format_list_bulleted,
  //           ),
  //           CustomTextField(
  //             title: 'Available Stock Quantity *',
  //             hintText: 'Enter stock quantity',
  //             controller: _stockQuantityController,
  //             keyboardType: TextInputType.number,
  //             prefixIcon: Icons.store,
  //             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             validator: (value) =>
  //             value?.isEmpty ?? true
  //                 ? 'Please enter stock quantity'
  //                 : null,
  //           ),
  //           CustomTextField(
  //             title: 'MRP (₹) *',
  //             hintText: 'Enter MRP',
  //             controller: _mrpController,
  //             keyboardType: TextInputType.number,
  //             prefixIcon: Icons.currency_rupee,
  //             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             validator: (value) =>
  //             value?.isEmpty ?? true
  //                 ? 'Please enter MRP'
  //                 : null,
  //           ),
  //           CustomTextField(
  //             title: 'Vendor Price (₹) *',
  //             hintText: 'Enter vendor price',
  //             controller: _vendorPriceController,
  //             keyboardType: TextInputType.number,
  //             prefixIcon: Icons.price_change,
  //             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             validator: (value) =>
  //             value?.isEmpty ?? true
  //                 ? 'Please enter vendor price'
  //                 : null,
  //           ),
  //           SizedBox(height: ResponsiveHelper.spacing(context, 12)),
  //           _buildUploadButton('Upload Product Images'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Step 6: Certifications
  Widget _buildStep6Certifications() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingAll(context, 16),
      child: Form(
        key: _formKeys[4],
        child: Column(
          children: [
            CustomTextField(
              title: 'FSSAI Certificate Number',
              hintText: 'Enter FSSAI certificate number',
              controller: _fssaiController,
              prefixIcon: Icons.verified,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            _buildUploadButton('Upload FSSAI Certificate'),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustomTextField(
              title: 'Organic Certification',
              hintText: 'Enter organic certification details',
              controller: _organicCertController,
              prefixIcon: Icons.eco,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            _buildUploadButton('Upload Organic Certificate'),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustomTextField(
              title: 'Agmark / Other Certificates',
              hintText: 'Enter certificate details',
              controller: _agmarkController,
              prefixIcon: Icons.card_membership,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            _buildUploadButton('Upload Agmark Certificate'),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustomTextField(
              title: 'Trade License Number',
              hintText: 'Enter trade license number',
              controller: _tradeLicenseController,
              prefixIcon: Icons.business_center,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            _buildUploadButton('Upload Trade License'),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            _buildUploadButton('Upload Other Certifications'),
          ],
        ),
      ),
    );
  }

  // Step 7: Logistics
  Widget _buildStep7Logistics() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingAll(context, 16),
      child: Form(
        key: _formKeys[5],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              title: 'Production Capacity per Month *',
              hintText: 'Enter production capacity',
              controller: _productionCapacityController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.production_quantity_limits,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter production capacity'
                  : null,
            ),
            CustomTextField(
              title: 'Minimum Order Quantity *',
              hintText: 'Enter minimum order quantity',
              controller: _minOrderQtyController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.shopping_cart,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter minimum order quantity'
                  : null,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 12)),
            Row(
              children: [
                SizedBox(
                  // width: 32,
                  height: ResponsiveHelper.containerHeight(context, 30),
                  child: Checkbox(
                    value: _hasBulkSupply,
                    onChanged: (value) =>
                        setState(() => _hasBulkSupply = value ?? false),
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact, // छोटा checkbox
                  ),
                ),
                Text(
                  'Bulk Supply Capability',
                  style: AppTextStyles.body1(
                    context,
                    overrideStyle: const TextStyle(
                      fontSize: 13.5,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 12)),
            Text(
              'Packaging Capability',
              style: AppTextStyles.body1(
                context,
                overrideStyle: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14),
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Own', style: AppTextStyles.body1(context)),
                    value: 'Own',
                    groupValue: _packagingCapability,
                    onChanged: (value) =>
                        setState(() => _packagingCapability = value!),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text(
                      'Outsourced',
                      style: AppTextStyles.body1(context),
                    ),
                    value: 'Outsourced',
                    groupValue: _packagingCapability,
                    onChanged: (value) =>
                        setState(() => _packagingCapability = value!),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),

            ResponsiveDropdown<String>(
              value: _shippingMethodController.text.isEmpty
                  ? null
                  : _shippingMethodController.text,
              itemList: const [
                'Road Transport',
                'Rail',
                'Air Cargo',
                'Own Vehicle',
                'Third Party Logistics',
              ],
              onChanged: (value) {
                if (value != null) _shippingMethodController.text = value;
              },
              hint: 'Select shipping method',
              label: 'Preferred Shipping Method',
              validator: (value) =>
                  value == null ? 'Please select shipping method' : null,
            ),
            CustomTextField(
              title: 'Dispatch TAT (Days) *',
              hintText: 'Enter dispatch turnaround time',
              controller: _dispatchTATController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.access_time,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => value?.isEmpty ?? true ? 'Please enter dispatch TAT' : null,
            ),
          ],
        ),
      ),
    );
  }

  // Step 8: Agreement
  Widget _buildStep8Agreement() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingAll(context, 16),
      child: Form(
        key: _formKeys[6],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Terms Box
            Container(
              width: double.infinity,
              padding: ResponsiveHelper.paddingAll(context, 14),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.blue[50],
                borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Conditions',
                    style: AppTextStyles.heading2(context),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Please read and accept the following terms to proceed.',
                    style: AppTextStyles.caption(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16), // थोड़ा breathing space

            // Compact Checkboxes
            _compactCheckbox(
              value: _commissionAccepted,
              onChanged: (v) => setState(() => _commissionAccepted = v ?? false),
              label: 'I accept the Commission Model',
            ),
            _compactCheckbox(
              value: _paymentSettlementAccepted,
              onChanged: (v) => setState(() => _paymentSettlementAccepted = v ?? false),
              label: 'I accept the Payment Settlement Cycle',
            ),
            _compactCheckbox(
              value: _returnPolicyAccepted,
              onChanged: (v) => setState(() => _returnPolicyAccepted = v ?? false),
              label: 'I accept the Return/Refund Policy',
            ),
            _compactCheckbox(
              value: _dataComplianceAccepted,
              onChanged: (v) => setState(() => _dataComplianceAccepted = v ?? false),
              label: 'I declare all provided data is accurate & compliant',
            ),

            const SizedBox(height: 16),

            // Digital Signature
            CustomTextField(
              title: 'Digital Signature *',
              hintText: 'Enter your full name as signature',
              controller: _signatureController,
              prefixIcon: Icons.draw,
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Please enter your signature';
                }
                if (!(_commissionAccepted &&
                    _paymentSettlementAccepted &&
                    _returnPolicyAccepted &&
                    _dataComplianceAccepted)) {
                  return 'Please accept all terms and conditions';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),
            _buildUploadButton('Upload Signed Vendor Agreement'),
          ],
        ),
      ),
    );
  }

// Reusable Compact Checkbox Widget (class के अंदर ही add कर दो)
  Widget _compactCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0), // कम vertical gap
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            // width: 32,
            height: ResponsiveHelper.containerHeight(context, 30),
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact, // छोटा checkbox
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body1(
                context,
                overrideStyle: const TextStyle(
                  fontSize: 13.5,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 9: Additional Information
  Widget _buildStep9AdditionalInfo() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingAll(context, 16),
      child: Form(
        key: _formKeys[6],
        child: Column(
          children: [
            Container(
              padding: ResponsiveHelper.paddingAll(context, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.green[50],
                borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                  Expanded(
                    child: Text(
                      'This section is optional. Providing additional information helps us serve you better.',
                      style: AppTextStyles.caption(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            _buildUploadButton('Upload Company Profile'),
            SizedBox(height: ResponsiveHelper.spacing(context, 12)),
            _buildUploadButton('Upload Brochure'),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustomTextField(
              title: 'Past Major Buyers',
              hintText: 'Enter names of past major buyers',
              controller: _pastBuyersController,
              prefixIcon: Icons.business,
              isMultiLine: true,
              maxLines: 3,
              minLines: 2,
            ),
            CustomTextField(
              title: 'Special Facilities',
              hintText:
                  'Enter special facilities (Cold Storage, Transport, etc.)',
              controller: _specialFacilitiesController,
              prefixIcon: Icons.warehouse,
              isMultiLine: true,
              maxLines: 3,
              minLines: 2,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 24)),
            Container(
              padding: ResponsiveHelper.paddingAll(context, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: ResponsiveHelper.iconSize(context, 24),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                  Expanded(
                    child: Text(
                      'You\'re almost done! Click Submit to complete your vendor registration.',
                      style: AppTextStyles.body1(
                        context,
                        overrideStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildUploadButton(String label) {
    return CustomButton(
      text: label,
      onPressed: () {
        // TODO: Implement file picker
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label feature will be implemented')),
        );
      },
      type: ButtonType.outlined,
      borderColor: AppColors.primary,
      textColor: AppColors.primary,
      height: 48,
      iconData: Icons.upload_file,
      iconPosition: IconPosition.left,
    );
  }

  // Dialog Methods
  void _showVendorTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Vendor Type',
          style: AppTextStyles.heading2(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              [
                    'FPO',
                    'SHG',
                    'Individual Farmer',
                    'MSME',
                    'Cooperative',
                    'Others',
                  ]
                  .map(
                    (type) => ListTile(
                      title: Text(type, style: AppTextStyles.body1(context)),
                      onTap: () {
                        setState(() => _vendorTypeController.text = type);
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  void _showStateDialog() {
    final states = [
      'Uttar Pradesh',
      'Maharashtra',
      'Karnataka',
      'Tamil Nadu',
      'Delhi',
      'Gujarat',
      'Rajasthan',
      'Punjab',
    ];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select State', style: AppTextStyles.heading2(context)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: states.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(states[index], style: AppTextStyles.body1(context)),
              onTap: () {
                setState(() => _stateController.text = states[index]);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  // void _showProductCategoryDialog() {
  //   final categories = [
  //     'Vegetables',
  //     'Fruits',
  //     'Grains',
  //     'Pulses',
  //     'Spices',
  //     'Dairy',
  //     'Organic Products'
  //   ];
  //   showDialog(
  //     context: context,
  //     builder: (context) =>
  //         AlertDialog(
  //           title: Text('Select Product Category',
  //               style: AppTextStyles.heading2(context)),
  //           content: SizedBox(
  //             width: double.maxFinite,
  //             child: ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: categories.length,
  //               itemBuilder: (context, index) =>
  //                   ListTile(
  //                     title: Text(categories[index],
  //                         style: AppTextStyles.body1(context)),
  //                     onTap: () {
  //                       setState(() =>
  //                       _productCategoryController.text = categories[index]);
  //                       Navigator.pop(context);
  //                     },
  //                   ),
  //             ),
  //           ),
  //         ),
  //   );
  // }

  void _showShippingMethodDialog() {
    final methods = [
      'Road Transport',
      'Rail',
      'Air Cargo',
      'Own Vehicle',
      'Third Party Logistics',
    ];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Shipping Method',
          style: AppTextStyles.heading2(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: methods
              .map(
                (method) => ListTile(
                  title: Text(method, style: AppTextStyles.body1(context)),
                  onTap: () {
                    setState(() => _shippingMethodController.text = method);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
}
