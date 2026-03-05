/// Route name constants for the application
class RouteNames {
  RouteNames._();

  // Core routes
  static const String splash = '/';
  static const String home = '/home';
  static const String malePoses = '/male-poses';
  static const String femalePoses = '/female-poses';
  static const String uploadBackground = '/upload-background';
  static const String previewPose = '/preview-pose';
  static const String wireframeCamera = '/wireframe-camera';
  static const String photoPreview = '/photo-preview';
  static const String gallery = '/gallery';
  static const String favourites = '/favourites';

  // Authentication routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verificationPending = '/verification-pending';
  static const String verifyEmail = '/verify-email';

  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';
  static const String privacyPolicy = '/profile/privacy-policy';

  // Add more route names as needed
  // Example:
  // static const String settings = '/settings';
  // static const String about = '/about';
}
