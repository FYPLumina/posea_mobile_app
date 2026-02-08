import 'package:posea_mobile_app/features/poses/data/datasources/pose_image_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/models/pose_model.dart';

class PoseImageRepository {
  final PoseImageApiService apiService;
  PoseImageRepository({required this.apiService});

  Future<bool> selectPose({required String poseId, required String accessToken}) async {
    return await apiService.selectPose(poseId: poseId, accessToken: accessToken);
  }

  Future<bool> captureImage({
    required String capturedImageBase64,
    required String poseId,
    required bool isFavourite,
    required String accessToken,
  }) async {
    return await apiService.captureImage(
      capturedImageBase64: capturedImageBase64,
      poseId: poseId,
      isFavourite: isFavourite,
      accessToken: accessToken,
    );
  }

  Future<String?> getPoseImageBase64(int imageId) async {
    return await apiService.fetchPoseImageBase64(imageId.toString());
  }

  Future<List<Pose>?> suggestPoses({
    required String imageBase64,
    required String accessToken,
  }) async {
    return await apiService.suggestPoses(imageBase64: imageBase64, accessToken: accessToken);
  }
}
