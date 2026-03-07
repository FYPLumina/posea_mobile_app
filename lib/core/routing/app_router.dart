import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/verification_pending_page.dart';
import 'package:posea_mobile_app/features/auth/presentation/pages/verify_email_page.dart';
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
import 'package:posea_mobile_app/features/profile/privacy_policy_screen.dart';
import 'package:posea_mobile_app/features/profile/profile_screens.dart';
import 'package:posea_mobile_app/features/splash/presentation/pages/splash_screen.dart';
import 'navigation_service.dart';
import 'route_names.dart';

/// Main app router configuration
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey = NavigationService.navigatorKey;

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      // Define your app routes here
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Authentication routes
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      // Registration route
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (context, state) => SignUpPage(),
      ),
      // Forgot password route
      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.resetPassword,
        name: RouteNames.resetPassword,
        builder: (context, state) =>
            ResetPasswordPage(initialToken: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: RouteNames.verificationPending,
        name: RouteNames.verificationPending,
        builder: (context, state) =>
            VerificationPendingPage(initialEmail: state.uri.queryParameters['email']),
      ),
      GoRoute(
        path: RouteNames.verifyEmail,
        name: RouteNames.verifyEmail,
        builder: (context, state) => VerifyEmailPage(
          initialOtp: state.uri.queryParameters['otp'] ?? state.uri.queryParameters['token'],
          initialEmail: state.uri.queryParameters['email'],
        ),
      ),
      // Main app routes
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      // male poses routes
      GoRoute(
        path: RouteNames.malePoses,
        name: RouteNames.malePoses,
        builder: (context, state) => const MalePosesPage(),
      ),
      //female poses routes
      GoRoute(
        path: RouteNames.femalePoses,
        name: RouteNames.femalePoses,
        builder: (context, state) => const FemalePosesPage(),
      ),
      // Profile routes
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        builder: (context, state) {
          // Lazy load the profile screen
          return const ProfileScreen();
        },
      ),
      // Edit profile route
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfile,
        builder: (context, state) {
          // Lazy load the edit profile screen
          return const EditProfileScreen();
        },
      ),
      // Change password route
      GoRoute(
        path: RouteNames.changePassword,
        name: RouteNames.changePassword,
        builder: (context, state) {
          // Lazy load the change password screen
          return const ChangePasswordScreen();
        },
      ),
      // Privacy policy route
      GoRoute(
        path: RouteNames.privacyPolicy,
        name: RouteNames.privacyPolicy,
        builder: (context, state) {
          return const PrivacyPolicyScreen();
        },
      ),
      // Background upload route
      GoRoute(
        path: RouteNames.uploadBackground,
        name: RouteNames.uploadBackground,
        builder: (context, state) {
          // Lazy load the upload background screen
          return const UploadBackgroundScreen();
        },
      ),
      // Pose preview route
      GoRoute(
        path: RouteNames.previewPose,
        name: RouteNames.previewPose,
        builder: (context, state) {
          // Lazy load the preview pose screen
          return PreviewPoseScreen();
        },
      ),
      // Wireframe camera route
      GoRoute(
        path: RouteNames.wireframeCamera,
        name: RouteNames.wireframeCamera,
        builder: (context, state) {
          // Lazy load the wireframe camera screen
          return const WireframeCameraScreen();
        },
      ),
      // Photo preview route with parameter
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
      // Gallery route
      GoRoute(
        path: RouteNames.gallery,
        name: RouteNames.gallery,
        builder: (context, state) {
          // Lazy load the gallery screen
          return const GalleryPage();
        },
      ),
      // Favourites route
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
