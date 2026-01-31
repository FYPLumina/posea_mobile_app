import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

/// HTTP API Client wrapper for handling network requests
class ApiClient {
  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  ApiClient({
    http.Client? client,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client();

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.get(uri, headers: headers).timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on http.ClientException {
      throw const NetworkException('Network error occurred');
    } on TimeoutException {
      throw const TimeoutException('Request timeout');
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .post(uri, headers: _buildHeaders(headers), body: body != null ? jsonEncode(body) : null)
          .timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on http.ClientException {
      throw const NetworkException('Network error occurred');
    } on TimeoutException {
      throw const TimeoutException('Request timeout');
    }
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .put(uri, headers: _buildHeaders(headers), body: body != null ? jsonEncode(body) : null)
          .timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on http.ClientException {
      throw const NetworkException('Network error occurred');
    } on TimeoutException {
      throw const TimeoutException('Request timeout');
    }
  }

  /// PATCH request
  Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .patch(uri, headers: _buildHeaders(headers), body: body != null ? jsonEncode(body) : null)
          .timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on http.ClientException {
      throw const NetworkException('Network error occurred');
    } on TimeoutException {
      throw const TimeoutException('Request timeout');
    }
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.delete(uri, headers: headers).timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on http.ClientException {
      throw const NetworkException('Network error occurred');
    } on TimeoutException {
      throw const TimeoutException('Request timeout');
    }
  }

  /// Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParameters.map((key, value) => MapEntry(key, value.toString())),
      );
    }
    return uri;
  }

  /// Build headers with default content type
  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    return {'Content-Type': 'application/json', 'Accept': 'application/json', ...?headers};
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    // Handle error responses
    final errorMessage = _extractErrorMessage(response);

    if (statusCode == 400) {
      throw ValidationException(errorMessage, code: statusCode.toString());
    } else if (statusCode == 401) {
      throw AuthenticationException(errorMessage, code: statusCode.toString());
    } else if (statusCode == 403) {
      throw AuthorizationException(errorMessage, code: statusCode.toString());
    } else if (statusCode == 404) {
      throw NotFoundException(errorMessage, code: statusCode.toString());
    } else if (statusCode >= 500) {
      throw ServerException(errorMessage, code: statusCode.toString());
    } else {
      throw ServerException('Unexpected error occurred', code: statusCode.toString());
    }
  }

  /// Extract error message from response
  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        return body['message'] ?? body['error'] ?? 'An error occurred';
      }
      return 'An error occurred';
    } catch (_) {
      return 'An error occurred';
    }
  }

  /// Close the client
  void close() {
    _client.close();
  }
}
