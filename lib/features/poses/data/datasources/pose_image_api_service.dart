import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posea_mobile_app/core/config/app_config.dart';
import 'package:posea_mobile_app/core/utils/logger.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/features/poses/data/models/pose_model.dart';

class PoseImageApiService {
  final String baseUrl;
  PoseImageApiService([String? baseUrl]) : baseUrl = baseUrl ?? AppConfig.baseUrl;
  Future<bool> selectPose({required String poseId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/pose/select');
    AppLogger.info('POST $url');
    AppLogger.info('Selecting pose with ID: $poseId');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({'pose_id': poseId}),
      );
      AppLogger.debug('Response: \\${response.statusCode} \\${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return json['success'] == true;
      }
      AppFeedback.showErrorSheet('Failed to select pose');
      return false;
    } catch (e, st) {
      AppLogger.error('Error selecting pose', e, st);
      AppFeedback.showErrorSheet('Failed to select pose');
      return false;
    }
  }

  Future<List<Pose>?> suggestPoses({
    required String imageBase64,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/background/suggest_poses');
    AppLogger.info('POST $url');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
        body: {'image_base64': imageBase64},
      );
      AppLogger.debug('Response: \${response.statusCode} \${response.body}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true && json['data'] != null) {
          final poses = (json['data']['poses'] as List).map((e) => Pose.fromJson(e)).toList();
          return poses;
        }
        final message = json['error']?.toString() ?? 'Failed to suggest poses';
        AppFeedback.showErrorSheet(message);
        return null;
      }
      AppFeedback.showErrorSheet('Failed to suggest poses');
      return null;
    } catch (e, st) {
      AppLogger.error('Error suggesting poses', e, st);
      AppFeedback.showErrorSheet('Failed to suggest poses');
      return null;
    }
  }

  Future<String?> fetchPoseImageBase64(String imageId) async {
    final url = Uri.parse('$baseUrl/pose/image_base64/$imageId');
    AppLogger.info('GET $url');
    try {
      final response = await http.get(url);
      AppLogger.debug('Response: \\${response.statusCode} \\${response.body}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true && json['data'] != null) {
          return json['data']['pose_image_base64'] as String?;
        }
        final message = json['error']?.toString() ?? 'Failed to load pose image';
        AppFeedback.showErrorSheet(message);
        return null;
      }
      AppFeedback.showErrorSheet('Failed to load pose image');
      return null;
    } catch (e, st) {
      AppLogger.error('Error fetching pose image base64', e, st);
      AppFeedback.showErrorSheet('Failed to load pose image');
      return null;
    }
  }

  Future<bool> captureImage({
    required String capturedImageBase64,
    required String poseId,
    required bool isFavourite,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/pose/capture_image');
    AppLogger.info('POST $url');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'captured_image_base64': capturedImageBase64,
          'pose_id': poseId,
          'is_favourite': isFavourite,
        }),
      );
      AppLogger.debug('Response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return json['success'] == true;
      }
      AppFeedback.showErrorSheet('Failed to save pose image');
      return false;
    } catch (e, st) {
      AppLogger.error('Error capturing pose image', e, st);
      AppFeedback.showErrorSheet('Failed to save pose image');
      return false;
    }
  }
}
