import '../config/app_config.dart';

/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - centralized in AppConfig
  static const String baseUrl = AppConfig.baseUrl;

  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';

  // Add more endpoints as needed for your app
  // Example:
  // static const String posts = '/posts';
  // static String postById(String id) => '/posts/$id';
}
