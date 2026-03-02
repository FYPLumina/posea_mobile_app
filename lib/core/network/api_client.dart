import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../routing/navigation_service.dart';
import '../routing/route_names.dart';
import '../errors/exceptions.dart';
import '../config/app_config.dart';
import '../utils/app_feedback.dart';

/// HTTP API Client wrapper for handling network requests
class ApiClient {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static bool _isRoutingToLogin = false;

  final http.Client _client;
  final String baseUrl;
  final Duration timeout;
  final int maxRetries;
  final Duration retryDelay;

  ApiClient({
    http.Client? client,
    String? baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
    this.retryDelay = const Duration(milliseconds: 500),
  }) : baseUrl = baseUrl ?? AppConfig.baseUrl,
       _client = client ?? http.Client();

  /// Executes a raw HTTP request with retry and timeout handling.
  Future<http.Response> sendRaw(Future<http.Response> Function() request) async {
    Exception? lastException;

    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await request().timeout(timeout);
        await _handleSessionExpiration(response);
        if (_shouldRetryStatusCode(response.statusCode) && attempt < maxRetries) {
          await Future.delayed(_retryDelayForAttempt(attempt));
          continue;
        }
        return response;
      } on SocketException catch (error) {
        lastException = error;
        if (attempt >= maxRetries) {
          throw const NetworkException('No internet connection');
        }
      } on http.ClientException catch (error) {
        lastException = error;
        if (attempt >= maxRetries) {
          throw const NetworkException('Network error occurred');
        }
      } on TimeoutException catch (error) {
        lastException = error;
        if (attempt >= maxRetries) {
          throw const TimeoutException('Request timeout');
        }
      }

      if (attempt < maxRetries) {
        await Future.delayed(_retryDelayForAttempt(attempt));
      }
    }

    if (lastException is SocketException) {
      throw const NetworkException('No internet connection');
    }
    if (lastException is http.ClientException) {
      throw const NetworkException('Network error occurred');
    }
    if (lastException is TimeoutException) {
      throw const TimeoutException('Request timeout');
    }
    throw const NetworkException('Network error occurred');
  }

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await sendRaw(() => _client.get(uri, headers: headers));
    return _handleResponse(response);
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await sendRaw(
      () => _client.post(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
    return _handleResponse(response);
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await sendRaw(
      () => _client.put(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
    return _handleResponse(response);
  }

  /// PATCH request
  Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await sendRaw(
      () => _client.patch(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
    return _handleResponse(response);
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await sendRaw(() => _client.delete(uri, headers: headers));
    return _handleResponse(response);
  }

  bool _shouldRetryStatusCode(int statusCode) {
    return statusCode == 429 || statusCode >= 500;
  }

  Duration _retryDelayForAttempt(int attempt) {
    final multiplier = 1 << (attempt - 1);
    return Duration(milliseconds: retryDelay.inMilliseconds * multiplier);
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
      AppFeedback.showErrorSheet(errorMessage);
      throw ValidationException(errorMessage, code: statusCode.toString());
    } else if (statusCode == 401) {
      AppFeedback.showErrorSheet(errorMessage);
      throw AuthenticationException(errorMessage, code: statusCode.toString());
    } else if (statusCode == 403) {
      AppFeedback.showErrorSheet(errorMessage);
      throw AuthorizationException(errorMessage, code: statusCode.toString());
    } else if (statusCode == 404) {
      AppFeedback.showErrorSheet(errorMessage);
      throw NotFoundException(errorMessage, code: statusCode.toString());
    } else if (statusCode >= 500) {
      AppFeedback.showErrorSheet(errorMessage);
      throw ServerException(errorMessage, code: statusCode.toString());
    } else {
      AppFeedback.showErrorSheet('Unexpected error occurred');
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

  Future<void> _handleSessionExpiration(http.Response response) async {
    if (response.statusCode != 401 && response.statusCode != 403) {
      return;
    }

    final errorText = _extractErrorMessage(response).toLowerCase();
    final bool isSessionExpired =
        errorText.contains('inactive user') ||
        errorText.contains('invalid authentication token') ||
        errorText.contains('token expired') ||
        errorText.contains('expired token') ||
        errorText.contains('not authenticated');

    if (!isSessionExpired || _isRoutingToLogin) {
      return;
    }

    _isRoutingToLogin = true;
    try {
      final context = NavigationService.context;
      if (context != null) {
        GoRouter.of(context).go(RouteNames.login);
      }
      await _storage.delete(key: 'access_token');
    } finally {
      _isRoutingToLogin = false;
    }
  }

  /// Close the client
  void close() {
    _client.close();
  }
}
