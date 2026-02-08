import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posea_mobile_app/core/utils/logger.dart';

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
    }
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
    }
    return null;
  }
}
