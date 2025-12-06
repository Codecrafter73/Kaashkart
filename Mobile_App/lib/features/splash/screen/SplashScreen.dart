import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/core/utls/storage_helper.dart';
import 'package:kaashtkart/features/auth/customer_login_screen.dart';
import 'package:kaashtkart/features/auth/intro_login_screen.dart';
import 'package:kaashtkart/features/customer/screen/bottom_navigation/entrypoint_ui.dart';
import 'package:kaashtkart/features/splash/controller/network_provider_controller.dart';
import 'package:kaashtkart/features/splash/screen/NoInternetScreen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkConnectivity());
  }

  void _checkConnectivity() async {
    await Future.delayed(const Duration(seconds: 1));

    bool isConnected = Provider.of<NetworkProvider>(
      context,
      listen: false,
    ).isConnected;

    if (!isConnected) {
      _navigateTo(NoInternetScreen());
      return;
    }

    final isLoggedIn =await StorageHelper().getBoolIsLoggedIn();
    final userId =await StorageHelper().getLoginUserId();
    if (isLoggedIn && userId.isNotEmpty) {
      _navigateTo(const CustomerEntryPointUI());
    } else {
      _navigateTo(const CustomerLoginFormScreen());
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/app_logo.png",
                  width: ResponsiveHelper.iconSize(context, 250),
                  height: ResponsiveHelper.iconSize(context, 250),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
