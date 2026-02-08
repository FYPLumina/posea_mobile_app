import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:posea_mobile_app/features/background/upload_background_screen.dart';
import 'package:posea_mobile_app/features/favourites/presentation/pages/favourites_page.dart';
import 'package:posea_mobile_app/features/gallery/presentation/pages/gallery_page.dart';
import 'package:posea_mobile_app/features/home/presentation/pages/home_page.dart';
import 'package:posea_mobile_app/features/poses/presentation/pages/female_poses_page.dart';
import 'package:posea_mobile_app/features/poses/presentation/pages/male_poses_page.dart';
import 'package:posea_mobile_app/features/poses/presentation/pages/photo_preview_screen.dart';
import 'package:posea_mobile_app/features/poses/presentation/pages/preview_pose_screen.dart';
import 'package:posea_mobile_app/features/poses/presentation/pages/wireframe_camera_screen.dart';
import 'package:posea_mobile_app/features/profile/change_password_screen.dart';
import 'package:posea_mobile_app/features/profile/profile_screens.dart';
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
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.malePoses,
        name: RouteNames.malePoses,
        builder: (context, state) => const MalePosesPage(),
      ),
      GoRoute(
        path: RouteNames.femalePoses,
        name: RouteNames.femalePoses,
        builder: (context, state) => const FemalePosesPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        builder: (context, state) {
          // Lazy load the profile screen
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfile,
        builder: (context, state) {
          // Lazy load the edit profile screen
          return const EditProfileScreen();
        },
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: RouteNames.changePassword,
        builder: (context, state) {
          // Lazy load the change password screen
          return const ChangePasswordScreen();
        },
      ),
      GoRoute(
        path: RouteNames.uploadBackground,
        name: RouteNames.uploadBackground,
        builder: (context, state) {
          // Lazy load the upload background screen
          return const UploadBackgroundScreen();
        },
      ),
      GoRoute(
        path: RouteNames.previewPose,
        name: RouteNames.previewPose,
        builder: (context, state) {
          // Lazy load the preview pose screen
          return PreviewPoseScreen();
        },
      ),
      GoRoute(
        path: RouteNames.wireframeCamera,
        name: RouteNames.wireframeCamera,
        builder: (context, state) {
          // Lazy load the wireframe camera screen
          return const WireframeCameraScreen();
        },
      ),
      GoRoute(
        path: RouteNames.photoPreview,
        name: RouteNames.photoPreview,
        builder: (context, state) {
          final map = state.extra is Map<String, dynamic>
              ? state.extra as Map<String, dynamic>
              : null;
          final imagePath = map?['imagePath'] as String?;
          return PhotoPreviewScreen(imagePath: imagePath ?? '');
        },
      ),
      GoRoute(
        path: RouteNames.gallery,
        name: RouteNames.gallery,
        builder: (context, state) {
          // Lazy load the gallery screen
          return const GalleryPage();
        },
      ),
      GoRoute(
        path: RouteNames.favourites,
        name: RouteNames.favourites,
        builder: (context, state) {
          // Lazy load the favourites screen
          return const FavouritesPage();
        },
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
