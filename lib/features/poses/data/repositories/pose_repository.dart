import 'package:posea_mobile_app/features/poses/data/datasources/pose_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/models/pose_model.dart';

class PoseRepository {
  final PoseApiService apiService;
  PoseRepository({required this.apiService});

  Future<List<Pose>> getPosesByGender(String gender, {int limit = 20, int offset = 0}) async {
    final response = await apiService.fetchPosesByGender(gender, limit: limit, offset: offset);
    if (response.success) {
      return response.poses;
    } else {
      throw Exception(response.error ?? 'Unknown error');
    }
  }
}
