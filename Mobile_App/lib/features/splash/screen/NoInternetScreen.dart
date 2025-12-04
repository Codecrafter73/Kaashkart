import 'package:flutter/material.dart';
import 'package:kaashtkart/core/utls/image_loader_util.dart';
import 'package:kaashtkart/features/splash/controller/network_provider_controller.dart';
import 'package:kaashtkart/features/splash/screen/SplashScreen.dart';
import 'package:provider/provider.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the network connection status from the provider
    bool isConnected = Provider.of<NetworkProvider>(context).isConnected;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageLoaderUtil.assetImage("assets/images/img_no_internet.png", width: 250), // Show No Internet Image
          SizedBox(height: 20),
          Text(
            "No Internet Connection!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("Please check your network and try again."),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<NetworkProvider>(context, listen: false).checkConnection(context);
              bool updatedConnectionStatus = Provider.of<NetworkProvider>(context, listen: false).isConnected;

              if (updatedConnectionStatus) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SplashScreen()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No internet connection. Please try again.")),
                );
              }
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }
}
