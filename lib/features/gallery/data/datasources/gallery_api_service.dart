import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posea_mobile_app/core/utils/logger.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';

class GalleryApiService {
  final String baseUrl;
  GalleryApiService(this.baseUrl);

  Future<List<Map<String, dynamic>>> fetchCapturedImages(String accessToken) async {
    final url = Uri.parse('$baseUrl/api/pose/captured_images');
    print('[GalleryApiService] About to call: GET $url');
    AppLogger.info('GET: $url');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
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
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
      body: jsonEncode({'cap_image_id': capImageId, 'is_favourite': isFavourite}),
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
}
