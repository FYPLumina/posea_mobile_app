import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService(this.baseUrl);

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await _storage.write(key: 'auth_token', value: token);
      return token;
    } else {
      throw Exception(_parseError(response));
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> signUp(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await _storage.write(key: 'auth_token', value: token);
      return token;
    } else {
      throw Exception(_parseError(response));
    }
  }

  Future<void> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/password-reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode != 200) {
      throw Exception(_parseError(response));
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/password-reset/confirm'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'password': newPassword}),
    );
    if (response.statusCode != 200) {
      throw Exception(_parseError(response));
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  String _parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['error'] ?? 'Unknown error';
    } catch (_) {
      return 'Unknown error';
    }
  }
}
