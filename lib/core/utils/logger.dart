import 'package:flutter/foundation.dart';

/// App logger utility for debugging and logging
class AppLogger {
  AppLogger._();

  static const String _tag = 'POSEA';

  /// Log info level message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[$_tag] ℹ️ INFO: $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  /// Log debug level message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[$_tag] 🔧 DEBUG: $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  /// Log warning level message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[$_tag] ⚠️ WARNING: $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  /// Log error level message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[$_tag] ❌ ERROR: $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  /// Log success level message
  static void success(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[$_tag] ✅ SUCCESS: $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  /// Log method entry
  static void methodEntry(String methodName) {
    if (kDebugMode) {
      print('[$_tag] 📥 ENTRY: $methodName()');
    }
  }

  /// Log method exit
  static void methodExit(String methodName, [dynamic result]) {
    if (kDebugMode) {
      print('[$_tag] 📤 EXIT: $methodName()');
      if (result != null) print('Result: $result');
    }
  }
}
