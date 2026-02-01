import 'package:flutter/material.dart';
import 'package:posea_mobile_app/core/network/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  bool _isLoading = false;
  String? _error;
  String? _token;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;

  AuthProvider(this.authService);

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      _token = await authService.login(email, password);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      _token = await authService.signUp(name, email, password);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await authService.logout();
    _token = null;
    notifyListeners();
  }

  Future<void> requestPasswordReset(String email) async {
    _setLoading(true);
    _error = null;
    try {
      await authService.requestPasswordReset(email);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
