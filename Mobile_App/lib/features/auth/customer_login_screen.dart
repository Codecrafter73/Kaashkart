import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/custom_buttons_utils.dart';
import 'package:kaashtkart/core/utls/responsive_dropdown_utils.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/bottom_navigation/entrypoint_ui.dart';
import 'package:kaashtkart/core/utls/custom_text_field_utils.dart';
import 'package:pinput/pinput.dart';

class CustomerLoginFormScreen extends StatefulWidget {
  const CustomerLoginFormScreen({super.key});

  @override
  State<CustomerLoginFormScreen> createState() =>
      _CustomerLoginFormScreenState();
}


class _CustomerLoginFormScreenState extends State<CustomerLoginFormScreen> {
  final PageController _pageController = PageController();
  int _currentTab = 0; // 0: Email Login, 1: Mobile Login, 2: Register
  final TextEditingController _otpController = TextEditingController();
  bool _showOtpField = false;

  // Form Keys
  final GlobalKey<FormState> _emailLoginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _mobileLoginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  // Email Login Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  // Mobile Login Controllers
  final TextEditingController _mobileController = TextEditingController();

  // Register Controllers
  final TextEditingController _regUsernameController = TextEditingController();
  final TextEditingController _regMobileController = TextEditingController();
  final TextEditingController _regDobController = TextEditingController();
  final TextEditingController _regGenderController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();
  final TextEditingController _regAddressController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _regUsernameController.dispose();
    _regMobileController.dispose();
    _regDobController.dispose();
    _regGenderController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    _regAddressController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    setState(() => _currentTab = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleEmailLogin() {
    if (_emailLoginFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email Login Successful!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CustomerEntryPointUI()),
      );
    }
  }

  void _handleMobileLogin() {
    if (_mobileLoginFormKey.currentState!.validate()) {
      setState(() => _showOtpField = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Sent Successfully!')),
      );
    }
  }

  // Naya method add karo:
  void _verifyOtp() {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP must be 6 digits')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Successful!')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CustomerEntryPointUI()),
    );
  }

  void _handleRegister() {
    if (_registerFormKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept Terms & Conditions')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account Created Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // ✅ Yeh add karo - back button remove ho jayega
        title: Text(
          'KaashKart',
          style: AppTextStyles.heading1(context,
            overrideStyle: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 20,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: isDark ? Colors.grey[850] : AppColors.primary,
      ),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              _buildTabBar(isDark),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildEmailLoginForm(),
                    _buildMobileLoginForm(),
                    _buildRegisterForm(),
                  ],
                ),
              ),
            ],
          ),


          // Bottom Background Image
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Image.asset(
          //     'assets/images/layer_bg.png', // ✅ Apna image path yahan daalein
          //     fit: BoxFit.cover,
          //     height: MediaQuery.of(context).size.height * 0.25, // Adjust height as needed
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: ResponsiveHelper.paddingSymmetric(
        context,
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: ResponsiveHelper.borderRadiusAll(context, 12),
      ),
      child: Row(
        children: [
          _buildTab('Email Login', 0),
          _buildTab('Mobile Login', 1),
          _buildTab('Register', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchTab(index),
        child: Container(
          padding: ResponsiveHelper.paddingSymmetric(
            context,
            vertical: 14,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: ResponsiveHelper.borderRadiusAll(context, 10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.body1(
              context,
              overrideStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Email Login Form
  Widget _buildEmailLoginForm() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingOnly(context,left:  20,right: 20,top: 10,bottom: 20),
      child: Form(
        key: _emailLoginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              title: 'Email',
              hintText: 'Enter your email',
              controller: _emailController,
              prefixIcon: Icons.email,
              letterSpacing: 1.2,
              keyboardType: TextInputType.emailAddress,
              validationType: ValidationType.email,
            ),
            CustomTextField(
              title: 'Password',
              hintText: 'Enter password',
              controller: _passwordController,
              prefixIcon: Icons.lock,
              letterSpacing: 1.2,
              isPassword: true,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter password' : null,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.8, // ⬅️ Checkbox chhota
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value ?? false),
                        activeColor: AppColors.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    Text(
                      'Remember me',
                      style: AppTextStyles.body1(context).copyWith(
                        fontSize: 12, // ⬅️ Text chhota
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12, // ⬅️ Text chhota
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 0)),
            CustomButton(
              text: 'Login',
              onPressed: _handleEmailLogin,
              color: AppColors.primary,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Center(
              child: Text(
                'or',
                style: AppTextStyles.body1(context).copyWith(
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            CustomButton(
              text: 'Login with Mobile OTP',
              type: ButtonType.outlined,
              onPressed: () => _switchTab(1),
              color: AppColors.primary,
              textColor: AppColors.primary,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.body1(context).copyWith(
                    fontSize: 12,
                  ),
                ),
                GestureDetector(
                  onTap: () => _switchTab(2),
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.heading1(context).copyWith(
                        fontSize: 14,
                        color: AppColors.primary
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 120), // ✅ Bottom padding for image space
          ],
        ),
      ),
    );
  }

  // Mobile Login Form
  Widget _buildMobileLoginForm() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingOnly(context,left:  20,right: 20,top: 10,bottom: 20),
      child: Form(
        key: _mobileLoginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              title: 'Mobile Number',
              hintText: 'Enter 10-digit mobile number',
              controller: _mobileController,
              prefixIcon: Icons.phone_android,
              letterSpacing: 1.2,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              validationType: ValidationType.phone,
              // inputFormatters: [
              //   FilteringTextInputFormatter.digitsOnly,
              //   LengthLimitingTextInputFormatter(10),
              // ],
              // validator: (value) {
              //   if (value?.isEmpty ?? true) return 'Please enter mobile number';
              //   if (value!.length != 10) return 'Mobile number must be 10 digits';
              //   return null;
              // },
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 10)),
            CustomButton(
              text: 'Get OTP',
              onPressed: _handleMobileLogin,
              color: AppColors.primary,
            ),
            if (_showOtpField) ...[
              SizedBox(height: ResponsiveHelper.spacing(context, 20)),
              Text(
                'Enter OTP',
                style: AppTextStyles.heading1(context, overrideStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
              ),
              SizedBox(height: ResponsiveHelper.spacing(context, 12)),
              Center(
                child: Pinput(
                  controller: _otpController,
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 55,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 50,
                    height: 55,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 50,
                    height: 55,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // onCompleted: (pin) => _verifyOtp(),
                ),
              ),
              // SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('OTP Resent Successfully!')),
                  );
                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CustomButton(
                text: 'Verify OTP',
                onPressed: _verifyOtp,
                color: AppColors.orangeColor,
                type: ButtonType.outlined,
                textColor: AppColors.orangeColor,
              ),
            ],
            // SizedBox(height: ResponsiveHelper.spacing(context, 0)),
            // Center(
            //   child: TextButton(
            //     onPressed: () => _switchTab(0),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Icon(Icons.arrow_back, size: 18, color: AppColors.primary),
            //         SizedBox(width: 4),
            //         Text(
            //           'Back to Email Login',
            //           style: TextStyle(
            //             color: AppColors.primary,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: ResponsiveHelper.spacing(context, 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.body1(context,overrideStyle: TextStyle(fontSize: 12)),
                ),
                GestureDetector(
                  onTap: () => _switchTab(2),
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.heading1(context,overrideStyle: TextStyle(fontSize: 14,color: AppColors.primary)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 120), // ✅ Bottom padding for image space
          ],
        ),
      ),
    );
  }

  // Register Form
  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.paddingOnly(context,left:  20,right: 20,top: 10,bottom: 20),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            CustomTextField(
              title: 'Username',
              hintText: 'Enter username',
              letterSpacing: 1.2,
              controller: _regUsernameController,
              keyboardType: TextInputType.name,
              validationType: ValidationType.name,
            ),
            CustomTextField(
              title: 'Mobile Number',
              hintText: '10-digit number',
              controller: _regMobileController,
              letterSpacing: 1.2,
              keyboardType: TextInputType.phone,
              validationType: ValidationType.phone,
              // inputFormatters: [
              //   FilteringTextInputFormatter.digitsOnly,
              //   LengthLimitingTextInputFormatter(10),
              // ],
              // validator: (value) {
              //   if (value?.isEmpty ?? true) return 'Required';
              //   if (value!.length != 10) return 'Invalid';
              //   return null;
              // },
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    title: 'Date of Birth',
                    hintText: 'Select Date of Birth',
                    controller: _regDobController,
                    readOnly: true,
                    letterSpacing: 1.2,
                    onTap: () => _selectDate(_regDobController),
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Select DOB' : null,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                Expanded(
                  child: ResponsiveDropdown<String>(
                    value: _regGenderController.text.isEmpty
                        ? null
                        : _regGenderController.text,
                    itemList: const ['Male', 'Female', 'Other'],
                    onChanged: (value) {
                      if (value != null) _regGenderController.text = value;
                    },
                    hint: 'Select',
                    label: 'Gender',
                    validator: (value) =>
                    value == null ? 'Select gender' : null,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    title: 'Email Address',
                    hintText: 'your.email@example.com',
                    controller: _regEmailController,
                    letterSpacing: 1.2,
                    keyboardType: TextInputType.emailAddress,
                    validationType: ValidationType.email,
                  ),
                ),
              ],
            ),
            CustomTextField(
              title: 'Password',
              hintText: 'Create password',
              controller: _regPasswordController,
              letterSpacing: 1.2,
              isPassword: true,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Enter password';
                if (value!.length < 6) return 'Min 6 chars';
                return null;
              },
            ),
            CustomTextField(
              title: 'Address',
              hintText: 'Enter Your Address.....',
              controller: _regAddressController,
              isMultiLine: true,
              maxLines: 3,
              minLines:3,
              letterSpacing: 1.2,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter address' : null,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 10)),
            Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 24,
                  child: Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) =>
                        setState(() => _agreeToTerms = value ?? false),
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'I agree to the Terms & Conditions and Privacy Policy',
                    style: AppTextStyles.body1(
                      context,
                      overrideStyle: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 10)),
            CustomButton(
              text: 'Create Account',
              onPressed: _handleRegister,
              color: AppColors.primary,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTextStyles.body1(context,overrideStyle: TextStyle(fontSize: 12)),
                ),
                GestureDetector(
                  onTap: () => _switchTab(0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 120), // ✅ Bottom padding for image space
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
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