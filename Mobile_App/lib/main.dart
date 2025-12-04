import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/theme/app_theme.dart';
import 'package:kaashtkart/features/customer/screen/cart/cart_controller.dart';
import 'package:kaashtkart/features/splash/controller/network_provider_controller.dart';
import 'package:kaashtkart/features/splash/screen/SplashScreen.dart';
import 'package:kaashtkart/core/utls/storage_helper.dart';
import 'package:provider/provider.dart';

// check for commit changes

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize CartProvider and load saved cart
  final cartStorage = StorageHelper();
  await cartStorage.init();
  CartProvider();


  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primary,
    statusBarIconBrightness: Brightness.light, // White icons on Android
    statusBarBrightness: Brightness.dark, // White icons on iOS
  ));



  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        title: 'KaashtKart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const FontTestScreen(),
//     );
//   }
// }
//
//
// class FontTestScreen extends StatelessWidget {
//   const FontTestScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Poppins Font Test'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text('Headline Large', style: textTheme.headlineLarge),
//             const SizedBox(height: 8),
//             Text('Headline Medium', style: textTheme.headlineMedium),
//             const SizedBox(height: 8),
//             Text('Headline Small', style: textTheme.headlineSmall),
//             const Divider(height: 32),
//
//             Text('Title Large', style: textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Text('Title Medium', style: textTheme.titleMedium),
//             const SizedBox(height: 8),
//             Text('Title Small', style: textTheme.titleSmall),
//             const Divider(height: 32),
//
//             Text('Body Large', style: textTheme.bodyLarge),
//             const SizedBox(height: 8),
//             Text('Body Medium', style: textTheme.bodyMedium),
//             const SizedBox(height: 8),
//             Text('Body Small', style: textTheme.bodySmall),
//             const Divider(height: 32),
//
//             Text('Label Large', style: textTheme.labelLarge),
//             const SizedBox(height: 8),
//             Text('Label Medium', style: textTheme.labelMedium),
//             const SizedBox(height: 8),
//             Text('Label Small', style: textTheme.labelSmall),
//             const Divider(height: 32),
//
//             const Text(
//               'Custom TextStyle Example',
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w600,
//                 fontSize: 20,
//                 color: Colors.deepPurple,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
