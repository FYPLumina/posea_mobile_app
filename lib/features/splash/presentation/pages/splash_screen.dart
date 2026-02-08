import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/logo_asset.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.initializing) {
          // Still loading token, show splash
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(child: LogoAsset(assetPath: 'assets/images/app_logo.svg', width: 400)),
            ),
          );
        } else {
          // After loading, navigate after a short delay
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Future.delayed(const Duration(seconds: 1));
            if (auth.isAuthenticated) {
              context.go('/home');
            } else {
              context.go('/login');
            }
          });
          // Show splash while routing
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(child: LogoAsset(assetPath: 'assets/images/app_logo.svg', width: 400)),
            ),
          );
        }
      },
    );
  }
}
