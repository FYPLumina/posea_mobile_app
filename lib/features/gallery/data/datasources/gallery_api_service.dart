import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posea_mobile_app/core/network/api_client.dart';
import 'package:posea_mobile_app/core/utils/logger.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';

class GalleryApiService {
  final String baseUrl;
  ApiClient? _apiClient;

  ApiClient get _client => _apiClient ??= ApiClient(baseUrl: baseUrl);

  GalleryApiService(this.baseUrl);

  Future<List<Map<String, dynamic>>> fetchCapturedImages(String accessToken) async {
    final url = Uri.parse('$baseUrl/api/pose/captured_images');
    print('[GalleryApiService] About to call: GET $url');
    AppLogger.info('GET: $url');
    final response = await _client.sendRaw(
      () => http.get(url, headers: {'Authorization': 'Bearer $accessToken'}),
    );
    print('[GalleryApiService] Response: ${response.statusCode} ${response.body}');
    AppLogger.debug('Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true && json['data'] != null) {
        return List<Map<String, dynamic>>.from(json['data']);
      }
      final message = json['error']?.toString() ?? 'Failed to load gallery images';
      AppFeedback.showErrorSheet(message);
      return [];
    }
    AppFeedback.showErrorSheet('Failed to load gallery images');
    return [];
  }

  Future<bool?> setFavourite({
    required String accessToken,
    required int capImageId,
    required bool isFavourite,
  }) async {
    final url = Uri.parse('$baseUrl/api/pose/set_favourite');
    AppLogger.info('POST: $url');
    final response = await _client.sendRaw(
      () => http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({'cap_image_id': capImageId, 'is_favourite': isFavourite}),
      ),
    );
    AppLogger.debug('Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true && json['data'] != null) {
        return json['data']['is_favourite'] == true;
      }
      final message = json['error']?.toString() ?? 'Failed to update favourite';
      AppFeedback.showErrorSheet(message);
      return null;
    }
    AppFeedback.showErrorSheet('Failed to update favourite');
    return null;
  }

  Future<bool> deleteCapturedImage({required String accessToken, required int capImageId}) async {
    final headers = {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'};

    final deleteCandidates = [
      Uri.parse('$baseUrl/api/pose/captured_images/$capImageId'),
      Uri.parse('$baseUrl/api/pose/delete_captured_image?cap_image_id=$capImageId'),
    ];

    for (final url in deleteCandidates) {
      try {
        AppLogger.info('DELETE: $url');
        final response = await _client.sendRaw(() => http.delete(url, headers: headers));
        AppLogger.debug('Response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          if (response.body.isEmpty) return true;
          final json = jsonDecode(response.body);
          return json['success'] == true;
        }
      } catch (_) {
        // Try next candidate endpoint.
      }
    }

    final postCandidates = [
      Uri.parse('$baseUrl/api/pose/delete_captured_image'),
      Uri.parse('$baseUrl/api/pose/delete_captured_images'),
      Uri.parse('$baseUrl/api/pose/remove_captured_image'),
    ];

    for (final url in postCandidates) {
      try {
        AppLogger.info('POST: $url');
        final response = await _client.sendRaw(
          () => http.post(url, headers: headers, body: jsonEncode({'cap_image_id': capImageId})),
        );
        AppLogger.debug('Response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          if (json['success'] == true) {
            return true;
          }
        }
      } catch (_) {
        // Try next candidate endpoint.
      }
    }

    AppFeedback.showErrorSheet('Failed to delete image.');
    return false;
  }
}
