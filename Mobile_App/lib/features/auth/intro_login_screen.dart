import 'package:flutter/material.dart';
import 'package:kaashtkart/core/utls/constants/app_images.dart';
import 'package:kaashtkart/features/auth/component/intro_page_body_area.dart';
import 'component/intro_page_background_wrapper.dart';


class IntroLoginPage extends StatelessWidget {
  const IntroLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          IntroLoginBackgroundWrapper(imageURL: AppImages.introBackground1),
          IntroPageBodyArea(),
        ],
      ),
    );
  }
}
