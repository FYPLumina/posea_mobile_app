import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posea_mobile_app/core/config/app_config.dart';

import 'package:posea_mobile_app/core/utils/logger.dart';
import '../models/pose_model.dart';

class PoseApiService {
  final String baseUrl;
  PoseApiService([String? baseUrl]) : baseUrl = baseUrl ?? AppConfig.baseUrl;

  Future<PoseListResponse> fetchPosesByGender(
    String gender, {
    int limit = 20,
    int offset = 0,
  }) async {
    final uri = Uri.parse('$baseUrl/pose/list?gender=$gender&limit=$limit&offset=$offset');
    AppLogger.info('GET $uri');
    try {
      final response = await http.get(uri);
      AppLogger.debug('Response: \\${response.statusCode} \\${response.body}');
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return PoseListResponse.fromJson(jsonBody);
      } else {
        AppLogger.error('Failed to load poses', response.body);
        throw Exception('Failed to load poses');
      }
    } catch (e, stack) {
      AppLogger.error('Exception during fetchPosesByGender', e, stack);
      rethrow;
    }
  }
}
