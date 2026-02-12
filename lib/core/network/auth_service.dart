import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../utils/app_feedback.dart';

class AuthService {
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService([String? baseUrl]) : baseUrl = baseUrl ?? AppConfig.baseUrl;

  //login API endpoint to authenticate a user and obtain an authentication token. Accepts email and password as parameters. Sends a POST request with the credentials in the request body. Handles errors by showing an error sheet with the appropriate message.
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await _storage.write(key: 'access_token', value: token);
      return token;
    } else {
      AppFeedback.showErrorSheet(_parseError(response));
      throw Exception(_parseError(response));
    }
  }

  //logout API endpoint to invalidate the user's authentication token. Accepts the authentication token as a parameter. Sends a POST request with the token in the Authorization header. Handles errors by showing an error sheet with the appropriate message.
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  //signUp API endpoint to create a new user account. Accepts email, password, and name as parameters. Sends a POST request with the user details in the request body. Handles errors by showing an error sheet with the appropriate message.
  Future<String?> signUp(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await _storage.write(key: 'access_token', value: token);
      return token;
    } else {
      AppFeedback.showErrorSheet(_parseError(response));
      throw Exception(_parseError(response));
    }
  }

  //requestPasswordReset API endpoint to initiate a password reset process. Accepts the user's email as a parameter. Sends a POST request with the email in the request body. Handles errors by showing an error sheet with the appropriate message.
  Future<void> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/password-reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode != 200) {
      AppFeedback.showErrorSheet(_parseError(response));
      throw Exception(_parseError(response));
    }
  }

  //resetPassword API endpoint to reset the user's password using a token received via email. Accepts the reset token and the new password as parameters. Sends a POST request with the token and new password in the request body. Handles errors by showing an error sheet with the appropriate message.
  Future<void> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/password-reset/confirm'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'password': newPassword}),
    );
    if (response.statusCode != 200) {
      AppFeedback.showErrorSheet(_parseError(response));
      throw Exception(_parseError(response));
    }
  }

  //getToken method to retrieve the stored authentication token from secure storage. Returns the token as a string if it exists, or null if it does not. This method is used to access the token for authenticated API requests.
  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }
  
  //isLoggedIn method to check if the user is currently logged in by verifying the presence of an authentication token in secure storage. Returns true if a token exists, indicating that the user is logged in, or false if no token is found.
  String _parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['error'] ?? 'Unknown error';
    } catch (_) {
      return 'Unknown error';
    }
  }
}
