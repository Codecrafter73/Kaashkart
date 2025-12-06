import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/constants.dart';
import 'package:kaashtkart/core/utls/constants/app_constants.dart';
import 'package:kaashtkart/features/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/custom_buttons_utils.dart';
import 'package:kaashtkart/core/utls/image_loader_util.dart';
import 'package:kaashtkart/core/utls/responsive_dropdown_utils.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/bottom_navigation/entrypoint_ui.dart';
import 'package:kaashtkart/core/utls/custom_text_field_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerLoginFormScreen extends StatefulWidget {
  const CustomerLoginFormScreen({super.key});

  @override
  State<CustomerLoginFormScreen> createState() =>
      _CustomerLoginFormScreenState();
}

class _CustomerLoginFormScreenState extends State<CustomerLoginFormScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentTab = 0;
  final TextEditingController _otpController = TextEditingController();
  bool _showOtpField = false;

  // Animation Controller for initial page load only
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
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

  /// ✅ Email Login with API Integration - FIXED
  Future<void> _handleEmailLogin() async {
    if (!_emailLoginFormKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> loginBody = {
      'Email': _emailController.text.trim(),
      'Password': _passwordController.text.trim(),
    };
    final authProvider = Provider.of<AuthApiProvider>(context, listen: false);
    await authProvider.loginUser(context, loginBody);
  }
  void _handleMobileLogin() {
    if (_mobileLoginFormKey.currentState!.validate()) {
      setState(() => _showOtpField = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP Sent Successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter OTP'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP must be 6 digits'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Login Successful!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
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
          SnackBar(
            content: const Text('Please accept Terms & Conditions'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account Created Successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey[900]!, Colors.grey[850]!]
                : [Colors.white, Colors.green[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(isDark),
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
              PoweredByFooter(), // ✅ Fixed footer sabke liye
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Column(
          children: [
            Container(
              width: ResponsiveHelper.containerWidth(context, 200),
              child: ImageLoaderUtil.assetImage(
                'assets/images/transparent_logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTab('Email', 0, Icons.email_rounded),
            _buildTab('Mobile', 1, Icons.phone_android_rounded),
            _buildTab('Register', 2, Icons.person_add_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, IconData icon) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _emailLoginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.9,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value ?? false),
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Text(
                      'Remember me',
                      style: AppTextStyles.body1(context).copyWith(fontSize: 13),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Consumer<AuthApiProvider>(
              builder: (context, authProvider, child) {
                final isLoading = authProvider.loginState.isLoading;

                return Column(
                  children: [
                    CustomButton(
                      text: isLoading ? 'Logging in...' : 'Login',
                      onPressed: isLoading ? null : _handleEmailLogin,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            IgnorePointer(
              child: CustomButton(
                text: 'Login with Mobile OTP',
                type: ButtonType.outlined,
                onPressed: () => _switchTab(1),
                color: AppColors.primary,
                textColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.body1(context).copyWith(fontSize: 13),
                ),
                GestureDetector(
                  onTap: () => _switchTab(2),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80), // Footer ke liye space
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _mobileLoginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CustomTextField(
              title: 'Mobile Number',
              hintText: 'Enter 10-digit mobile number',
              controller: _mobileController,
              prefixIcon: Icons.phone_android,
              letterSpacing: 1.2,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              validationType: ValidationType.phone,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Get OTP',
              onPressed: _handleMobileLogin,
              color: AppColors.primary,
            ),
            if (_showOtpField) ...[
              const SizedBox(height: 24),
              Text(
                'Enter OTP',
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                      borderRadius: BorderRadius.circular(12),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 50,
                    height: 55,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('OTP Resent Successfully!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
            const SizedBox(height: 80), // Footer ke liye space
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            const SizedBox(height: 8),
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
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    title: 'Date of Birth',
                    hintText: 'Select DOB',
                    controller: _regDobController,
                    readOnly: true,
                    letterSpacing: 1.2,
                    onTap: () => _selectDate(_regDobController),
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Select DOB' : null,
                  ),
                ),
                const SizedBox(width: 12),
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
            CustomTextField(
              title: 'Email Address',
              hintText: 'your.email@example.com',
              controller: _regEmailController,
              letterSpacing: 1.2,
              keyboardType: TextInputType.emailAddress,
              validationType: ValidationType.email,
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
              minLines: 3,
              letterSpacing: 1.2,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter address' : null,
            ),
            const SizedBox(height: 12),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'I agree to the Terms & Conditions and Privacy Policy',
                    style: AppTextStyles.body1(
                      context,
                      overrideStyle: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Create Account',
              onPressed: _handleRegister,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTextStyles.body1(context).copyWith(fontSize: 13),
                ),
                GestureDetector(
                  onTap: () => _switchTab(0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80), // Footer ke liye space
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

// ✅ Reusable PoweredBy Footer Widget
class PoweredByFooter extends StatelessWidget {
   PoweredByFooter({super.key});

  final Uri _url =  Uri.parse(
    AppDefaultConstants.codeCrafterSiteUrl,
  );

  Future<void> _launchURL(BuildContext context) async {
    try {
      if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Powered by ",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () => _launchURL(context),
            child: ImageLoaderUtil.assetImage(
              "assets/images/code_crafter_logo.png",
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}