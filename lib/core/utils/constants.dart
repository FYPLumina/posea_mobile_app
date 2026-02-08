/// App-wide constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'POSEA';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 5);
  static const Duration mediumTimeout = Duration(seconds: 15);
  static const Duration longTimeout = Duration(seconds: 60);

  // Delays
  static const Duration navigationDelay = Duration(milliseconds: 300);
  static const Duration animationDuration = Duration(milliseconds: 500);

  // Sizes
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;

  // Empty states
  static const String emptyStateTitle = 'No Data';
  static const String emptyStateMessage = 'No data available at the moment';
  static const String errorStateTitle = 'Error';
  static const String errorStateMessage = 'Something went wrong. Please try again.';
  static const String loadingMessage = 'Loading...';

  // Pagination
  static const int defaultPageSize = 20;
  static const int initialPage = 1;

  // Cache keys
  static const String cacheKeyUser = 'cache_user';
  static const String cacheKeyAuthToken = 'cache_auth_token';
  static const String cacheKeyTheme = 'cache_theme';

  // Shared preferences keys
  static const String prefsKeyUserToken = 'user_token';
  static const String prefsKeyUserId = 'user_id';
  static const String prefsKeyIsDarkMode = 'is_dark_mode';
  static const String prefsKeyLanguage = 'language';

  // Error messages
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
  static const String noInternetConnection = 'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorized = 'Unauthorized. Please login again.';
  static const String notFound = 'Resource not found.';

  // Success messages
  static const String successfullyCreated = 'Created successfully!';
  static const String successfullyUpdated = 'Updated successfully!';
  static const String successfullyDeleted = 'Deleted successfully!';
  static const String successfullySaved = 'Saved successfully!';
}
