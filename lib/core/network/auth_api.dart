import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import 'api_client.dart';
import '../utils/app_feedback.dart';

class AuthApi {
  final String baseUrl;
  final Logger _logger = Logger();
  ApiClient? _apiClient;

  ApiClient get _client => _apiClient ??= ApiClient(baseUrl: baseUrl);

  AuthApi([String? baseUrl]) : baseUrl = baseUrl ?? AppConfig.baseUrl;

  //getprofile API endpoint to fetch user profile data, requires authentication token in the header. Returns a map containing user details like name, email, bio, and profile image URL. Handles errors by showing an error sheet with the appropriate message.
  Future<Map<String, dynamic>> getProfile({required String token}) async {
    _logger.i('GET $baseUrl/auth/profile');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    final response = await _client.sendRaw(
      () => http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  //register API endpoint to create a new user account. Accepts email, password, and name as parameters. Sends a POST request with the user details in the request body. Handles errors by showing an error sheet with the appropriate message.
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _logger.i('POST $baseUrl/auth/register');
    _logger.i('Request body: {email: $email, password: $password, name: $name}');
    final response = await _client.sendRaw(
      () => http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'name': name}),
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  //login API endpoint to authenticate a user and obtain an authentication token. Accepts email and password as parameters. Sends a POST request with the credentials in the request body. Handles errors by showing an error sheet with the appropriate message.
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    _logger.i('POST $baseUrl/auth/login');
    _logger.i('Request body: {email: $email, password: $password}');
    final response = await _client.sendRaw(
      () => http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    return _decodeResponseWithStatus(response);
  }

  //logout API endpoint to invalidate the user's authentication token. Accepts the authentication token as a parameter. Sends a POST request with the token in the Authorization header. Handles errors by showing an error sheet with the appropriate message.
  Future<Map<String, dynamic>> logout({required String token}) async {
    _logger.i('POST $baseUrl/auth/logout');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    final response = await _client.sendRaw(
      () => http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  //updateProfile API endpoint to update the user's profile information. Accepts the authentication token, name, optional bio, and optional profile image (either as a base64 string or a local file path) as parameters. Sends a PUT request with the updated profile details in multipart/form-data format. Handles errors by showing an error sheet with the appropriate message.
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
    _logger.i('Request fields: {name: $name, bio: $bio}');
    if (imageFilePath != null) _logger.i('Uploading file: $imageFilePath');
    final response = await _client.sendRaw(() async {
      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = name;
      if (bio != null) request.fields['bio'] = bio;
      if (profileImageBase64 != null) {
        request.fields['profile_image_base64'] = profileImageBase64;
      } else if (imageFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath('file', imageFilePath));
      }
      final streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    });
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  //change-password API endpoint to change the user's password. Accepts the authentication token, old password, and new password as parameters. Sends a POST request with the old and new passwords in the request body. Handles errors by showing an error sheet with the appropriate message.
  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    _logger.i('POST $baseUrl/auth/change-password');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    _logger.i('Request body: {old_password: $oldPassword, new_password: $newPassword}');
    final response = await _client.sendRaw(
      () => http.post(
        Uri.parse('$baseUrl/auth/change-password'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({'old_password': oldPassword, 'new_password': newPassword}),
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  //deleteAccount API endpoint to delete the user's account. Accepts the authentication token as a parameter. Sends a DELETE request with the token in the Authorization header. Handles errors by showing an error sheet with the appropriate message.
  Future<Map<String, dynamic>> deleteAccount({required String token}) async {
    final response = await _client.sendRaw(
      () => http.delete(
        Uri.parse('$baseUrl/auth/'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      ),
    );
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> removeProfileImage({required String token}) async {
    _logger.i('DELETE $baseUrl/profile/image');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    final response = await _client.sendRaw(
      () => http.delete(
        Uri.parse('$baseUrl/profile/image'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> clearBio({required String token}) async {
    _logger.i('DELETE $baseUrl/profile/bio');
    _logger.i('Request headers: {Authorization: Bearer $token}');
    final response = await _client.sendRaw(
      () => http.delete(
        Uri.parse('$baseUrl/profile/bio'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    _logger.i('POST $baseUrl/auth/forgot-password');
    _logger.i('Request body: {email: $email}');
    final response = await _client.sendRaw(
      () => http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    _logger.i('POST $baseUrl/auth/reset-password');
    _logger.i('Request body: {token: $token, new_password: $newPassword}');
    final response = await _client.sendRaw(
      () => http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'new_password': newPassword}),
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    return _decodeResponseWithStatus(response);
  }

  Future<Map<String, dynamic>> verifyEmail({required String token}) async {
    _logger.i('POST $baseUrl/auth/verify-email');
    _logger.i('Request body: {token: $token}');
    final response = await _client.sendRaw(
      () => http.post(
        Uri.parse('$baseUrl/auth/verify-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    return _decodeResponseWithStatus(response);
  }

  Future<Map<String, dynamic>> resendVerification({required String email}) async {
    _logger.i('POST $baseUrl/auth/resend-verification');
    _logger.i('Request body: {email: $email}');
    final response = await _client.sendRaw(
      () => http.post(
        Uri.parse('$baseUrl/auth/resend-verification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ),
    );
    _logger.i('Response: ${response.statusCode} ${response.body}');
    _handleErrorResponse(response);
    return jsonDecode(response.body);
  }

  Map<String, dynamic> _decodeResponseWithStatus(http.Response response) {
    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return {...decoded, '_statusCode': response.statusCode};
    }
    return {'success': false, 'error': 'Unexpected response', '_statusCode': response.statusCode};
  }

  // Helper method to handle error responses and show appropriate error messages using AppFeedback. If the response status code indicates an error (400 or above), it attempts to parse the error message from the response body and displays it in an error sheet. If parsing fails, it shows a generic error message.
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
