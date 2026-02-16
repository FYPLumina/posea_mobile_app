import 'package:flutter/material.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';

// ===== String Extensions =====
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  /// Check if string is email
  bool get isEmail => RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);

  /// Check if string is phone number
  bool get isPhoneNumber =>
      RegExp(r'^[+]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,4}[-\s.]?[0-9]{1,9}$').hasMatch(this);

  /// Check if string is URL
  bool get isUrl {
    try {
      Uri.parse(this);
      return startsWith('http://') || startsWith('https://');
    } catch (_) {
      return false;
    }
  }

  /// Check if string is numeric
  bool get isNumeric => num.tryParse(this) != null;

  /// Remove all whitespace
  String get removeAllWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Truncate string to max length
  String truncate(int maxLength) {
    return length > maxLength ? '${substring(0, maxLength)}...' : this;
  }
}

// ===== DateTime Extensions =====
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Get formatted date string (dd/MM/yyyy)
  String get formattedDate => '$day/${month.toString().padLeft(2, '0')}/$year';

  /// Get formatted time string (HH:mm)
  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Get formatted datetime string (dd/MM/yyyy HH:mm)
  String get formattedDateTime => '$formattedDate $formattedTime';

  /// Get relative time (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formattedDate;
    }
  }
}

// ===== List Extensions =====
extension ListExtensions<T> on List<T> {
  /// Check if list is empty or null
  bool get isEmptyOrNull => isEmpty;

  /// Check if list is not empty
  bool get isNotEmptyOrNull => isNotEmpty;

  /// Get first element or null
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null
  T? get lastOrNull => isEmpty ? null : last;

  /// Safely get element at index
  T? getAtIndex(int index) => index >= 0 && index < length ? this[index] : null;
}

// ===== BuildContext Extensions =====
extension BuildContextExtensions on BuildContext {
  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if device is in portrait
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Check if device is in landscape
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if device is tablet (width > 600)
  bool get isTablet => screenWidth > 600;

  /// Check if device is phone
  bool get isPhone => !isTablet;

  /// Get device padding
  EdgeInsets get devicePadding => mediaQuery.padding;

  /// Get device view insets
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Show snackbar
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    AppFeedback.showSuccessSheet('Notice', message);
  }

  /// Show error snackbar
  void showErrorSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    AppFeedback.showErrorSheet(message);
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    AppFeedback.showSuccessSheet('Success', message);
  }

  /// Pop navigation
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Push named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  /// Push replacement route
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);

  /// Pop until
  void popUntil(String routeName) => Navigator.of(this).popUntil(ModalRoute.withName(routeName));
}

// ===== Num Extensions =====
extension NumExtensions on num {
  /// Convert to boolean (0 = false, non-zero = true)
  bool get toBool => this != 0;

  /// Check if number is even
  bool get isEven => (toInt() % 2) == 0;

  /// Check if number is odd
  bool get isOdd => (toInt() % 2) != 0;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Format as currency (e.g., $1,234.56)
  String formatAsCurrency({String symbol = '\$', int decimals = 2}) {
    final formatted = toStringAsFixed(decimals);
    return '$symbol$formatted';
  }

  /// Format as percentage
  String formatAsPercentage({int decimals = 1}) {
    return '${toStringAsFixed(decimals)}%';
  }
}

// ===== Map Extensions =====
extension MapExtensions<K, V> on Map<K, V> {
  /// Check if map is empty or null
  bool get isEmptyOrNull => isEmpty;

  /// Check if map is not empty
  bool get isNotEmptyOrNull => isNotEmpty;

  /// Get value for key or null
  V? getValueOrNull(K key) => this[key];
}
