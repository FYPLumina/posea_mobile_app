import 'package:flutter/material.dart';

import '../../../../core/widgets/logo_asset.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(child: LogoAsset(assetPath: 'assets/images/app_logo.svg', width: 400)),
      ),
    );
  }
}
