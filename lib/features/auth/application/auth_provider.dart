import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/auth_api.dart';

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

  Map<String, dynamic>? _profile;
  Map<String, dynamic>? get profile => _profile;
  String get userName => _profile?['name'] ?? '';
  String get userEmail => _profile?['email'] ?? '';
  String get userBio => _profile?['bio'] ?? '';
  String get userImage => _profile?['profile_image'] ?? '';

  AuthProvider(this.api) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await _storage.read(key: 'access_token');
    if (_token != null) {
      await fetchProfile();
    }
    _initializing = false;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await api.register(email: email, password: password, name: name);
      if (res['success'] == true) {
        // Optionally auto-login or handle as needed
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
      if (res['success'] == true && res['data'] != null) {
        _token = res['data']['access_token'];
        await _storage.write(key: 'access_token', value: _token);
        await fetchProfile();
        notifyListeners();
        return true;
      } else {
        _error = res['error']?.toString() ?? 'Login failed';
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

  Future<void> fetchProfile() async {
    if (_token == null) return;
    try {
      final res = await api.getProfile(token: _token!);
      if (res['success'] == true && res['data'] != null) {
        _profile = res['data'];
      } else if (res['error']?.toString().contains('Invalid authentication token') == true) {
        await logout();
      }
    } catch (e) {
      // Optionally handle other errors
    }
    notifyListeners();
  }
}
