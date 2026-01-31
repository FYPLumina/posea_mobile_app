/// Input validation utilities
class Validators {
  Validators._();

  static const String _emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String _phoneRegex = r'^[+]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,4}[-\s.]?[0-9]{1,9}$';
  static const String _passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(_emailRegex).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(_passwordRegex).hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, number and special character';
    }
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String label = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$label is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, {String label = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$label is required';
    }
    if (value.length < minLength) {
      return '$label must be at least $minLength characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, {String label = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$label is required';
    }
    if (value.length > maxLength) {
      return '$label must be at most $maxLength characters';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(_phoneRegex).hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    try {
      Uri.parse(value);
      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return 'URL must start with http:// or https://';
      }
      return null;
    } catch (_) {
      return 'Please enter a valid URL';
    }
  }

  /// Validate number format
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number is required';
    }
    if (int.tryParse(value) == null && double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  /// Check if email is valid
  static bool isValidEmail(String email) {
    return RegExp(_emailRegex).hasMatch(email);
  }

  /// Check if password is strong
  static bool isStrongPassword(String password) {
    return RegExp(_passwordRegex).hasMatch(password);
  }

  /// Check if phone number is valid
  static bool isValidPhoneNumber(String phone) {
    return RegExp(_phoneRegex).hasMatch(phone);
  }

  /// Check if URL is valid
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return url.startsWith('http://') || url.startsWith('https://');
    } catch (_) {
      return false;
    }
  }
}
