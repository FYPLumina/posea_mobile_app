/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - Update this with your actual API base URL
  static const String baseUrl = 'https://api.yourapp.com/v1';

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
