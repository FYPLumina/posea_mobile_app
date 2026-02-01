import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/logo_asset.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        context.go('/login');
      });
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(child: LogoAsset(assetPath: 'assets/images/app_logo.svg', width: 400)),
      ),
    );
  }
}
