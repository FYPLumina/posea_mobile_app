import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import '../utils/app_feedback.dart';

class AuthApi {
  final String baseUrl;
  final Logger _logger = Logger();

  AuthApi([String? baseUrl]) : baseUrl = baseUrl ?? AppConfig.baseUrl;

  Future<Map<String, dynamic>> getProfile({required String token}) async {
    _logger.i('GET $baseUrl/auth/profile');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _logger.i('POST $baseUrl/auth/register');
    _logger.i('Request body: {email: $email, password: $password, name: $name}');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    _logger.i('POST $baseUrl/auth/login');
    _logger.i('Request body: {email: $email, password: $password}');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> logout({required String token}) async {
    _logger.i('POST $baseUrl/auth/logout');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String name,
    String? bio,
    String? profileImageBase64,
    String? imageFilePath, // local file path for image
  }) async {
    _logger.i('PUT $baseUrl/auth/profile (multipart/form-data)');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    final uri = Uri.parse('$baseUrl/auth/profile');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    if (bio != null) request.fields['bio'] = bio;
    if (profileImageBase64 != null) {
      request.fields['profile_image_base64'] = profileImageBase64;
    } else if (imageFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', imageFilePath));
    }
    _logger.i('Request fields: ${request.fields.toString()}');
    if (imageFilePath != null) _logger.i('Uploading file: $imageFilePath');
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    _logger.i('POST $baseUrl/auth/change-password');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    _logger.i('Request body: {old_password: $oldPassword, new_password: $newPassword}');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/change-password'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'old_password': oldPassword, 'new_password': newPassword}),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteAccount({required String token}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  void _handleErrorResponse(http.Response response) {
    if (response.statusCode < 400) return;
    try {
      final data = jsonDecode(response.body);
      final message = data is Map<String, dynamic>
          ? (data['error']?.toString() ?? data['message']?.toString() ?? 'Request failed')
          : 'Request failed';
      AppFeedback.showErrorSheet(message);
    } catch (_) {
      AppFeedback.showErrorSheet('Request failed');
    }
  }
}
