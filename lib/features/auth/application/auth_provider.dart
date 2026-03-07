import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/navigation_service.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import '../../../core/network/auth_api.dart';

enum AuthFlowState { unverified, verificationPending, verified, resetPending }

class AuthProvider extends ChangeNotifier {
  final AuthApi api;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  String? _error;
  String? get error => _error;

  bool _loading = false;
  bool get loading => _loading;

  bool _initializing = true;
  bool get initializing => _initializing;

  AuthFlowState _authFlowState = AuthFlowState.unverified;
  AuthFlowState get authFlowState => _authFlowState;

  String? _pendingEmail;
  String? get pendingEmail => _pendingEmail;

  // User profile data
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? get profile => _profile;
  String get userName => _profile?['name'] ?? '';
  String get userEmail => _profile?['email'] ?? '';
  String get userBio => _profile?['bio'] ?? '';
  String get userImage => _profile?['profile_image'] ?? '';

  AuthProvider(this.api) {
    _loadToken();
  }

  // Load token from secure storage and fetch profile if token exists
  Future<void> _loadToken() async {
    _token = await _storage.read(key: 'access_token');
    if (_token != null) {
      await fetchProfile();
    }
    _initializing = false;
    notifyListeners();
  }

  // Register a new user with the provided name, email, and password
  Future<bool> register(String name, String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.register(email: email, password: password, name: name);
      if (res['success'] == true) {
        _error = null;
        _pendingEmail = email;
        _authFlowState = AuthFlowState.verificationPending;
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Registration failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.login(email: email, password: password);
      final statusCode = res['_statusCode'] is int ? res['_statusCode'] as int : null;
      if (res['success'] == true && res['data'] != null) {
        _token = res['data']['access_token'];
        await _storage.write(key: 'access_token', value: _token);
        await fetchProfile();
        _error = null;
        _authFlowState = AuthFlowState.verified;
        _pendingEmail = null;
        notifyListeners();
        return true;
      } else {
        if (statusCode == 401) {
          _error = 'Invalid email or password';
        } else if (statusCode == 403) {
          _error = 'Please verify your email first';
          _pendingEmail = email;
          _authFlowState = AuthFlowState.verificationPending;
        } else {
          _error = res['error']?.toString() ?? 'Login failed';
        }
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_token == null) return;
    _loading = true;
    notifyListeners();
    try {
      await api.logout(token: _token!);
    } catch (_) {}
    _token = null;
    _error = null;
    _profile = null;
    _authFlowState = AuthFlowState.unverified;
    await _storage.delete(key: 'access_token');
    _loading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(String name, {String? bio, String? profileImageBase64}) async {
    if (_token == null) return false;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.updateProfile(
        token: _token!,
        name: name,
        bio: bio,
        profileImageBase64: profileImageBase64,
      );
      if (res['success'] == true) {
        await fetchProfile();
        _error = null;
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Update failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_token == null) return false;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.changePassword(
        token: _token!,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      if (res['success'] == true) {
        _error = null;
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Change password failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAccount() async {
    if (_token == null) return false;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.deleteAccount(token: _token!);
      if (res['success'] == true) {
        await logout();
        _error = null;
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Delete failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> removeProfileImage() async {
    if (_token == null) return false;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.removeProfileImage(token: _token!);
      if (res['success'] == true) {
        if (res['data'] != null && res['data'] is Map<String, dynamic>) {
          _profile = res['data'];
        } else {
          await fetchProfile();
        }
        _error = null;
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Remove profile image failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> clearBio() async {
    if (_token == null) return false;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.clearBio(token: _token!);
      if (res['success'] == true) {
        if (res['data'] != null && res['data'] is Map<String, dynamic>) {
          _profile = res['data'];
        } else {
          await fetchProfile();
        }
        _error = null;
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Clear bio failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.forgotPassword(email: email);
      if (res['success'] == true) {
        _error = null;
        _authFlowState = AuthFlowState.resetPending;
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Forgot password request failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPasswordWithToken(String resetToken, String newPassword) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.resetPassword(token: resetToken, newPassword: newPassword);
      if (res['success'] == true) {
        _error = null;
        _token = null;
        _profile = null;
        _authFlowState = AuthFlowState.unverified;
        await _storage.delete(key: 'access_token');
        return true;
      } else if (res['_statusCode'] == 400) {
        _error = 'Token invalid or expired';
        return false;
      } else {
        _error = res['error']?.toString() ?? 'Reset password failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyEmailOtp({required String email, required String otp}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.verifyEmail(email: email, otp: otp);
      if (res['success'] == true) {
        _authFlowState = AuthFlowState.verified;
        _error = null;
        return true;
      } else if (res['_statusCode'] == 400) {
        _error = 'OTP invalid or expired';
        return false;
      } else {
        _error = res['error']?.toString() ?? 'Email verification failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> resendVerificationEmail(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.resendVerification(email: email);
      if (res['success'] == true) {
        _pendingEmail = email;
        _authFlowState = AuthFlowState.verificationPending;
        _error = null;
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Resend verification failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    if (_token == null) return;
    try {
      final res = await api.getProfile(token: _token!);
      if (res['success'] == true && res['data'] != null) {
        _profile = res['data'];
      } else {
        final errorMessage = res['error']?.toString().toLowerCase() ?? '';
        final bool isInvalidToken = errorMessage.contains('invalid authentication token');
        final bool isInactiveUser = errorMessage.contains('inactive user');

        if (isInvalidToken || isInactiveUser) {
          await _forceLogoutAndRouteToLogin();
        }
      }
    } catch (e) {
      // Optionally handle other errors
    }
    notifyListeners();
  }

  Future<void> _forceLogoutAndRouteToLogin() async {
    _token = null;
    _profile = null;
    _error = null;
    _authFlowState = AuthFlowState.unverified;
    final context = NavigationService.context;
    if (context != null) {
      GoRouter.of(context).go(RouteNames.login);
    }

    await _storage.delete(key: 'access_token');
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  void setPendingEmail(String email) {
    _pendingEmail = email;
    _authFlowState = AuthFlowState.verificationPending;
    notifyListeners();
  }
}
