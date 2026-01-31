import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/features/splash/presentation/pages/splash_screen.dart';
import 'route_names.dart';

/// Main app router configuration
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Add more routes here as you create features
      // Example:
      // GoRoute(
      //   path: RouteNames.home,
      //   name: RouteNames.home,
      //   builder: (context, state) => const HomeScreen(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(state.uri.toString(), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.splash),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
