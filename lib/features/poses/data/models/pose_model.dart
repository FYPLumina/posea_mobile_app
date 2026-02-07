class Pose {
  final int poseId;
  final String poseImage;
  final String? description;
  final String? skeletonData;
  final String? sceneTag;
  final String? lightingTag;
  final String gender;
  final String? poseImageBase64;

  Pose({
    required this.poseId,
    required this.poseImage,
    this.poseImageBase64,
    this.description,
    this.skeletonData,
    this.sceneTag,
    this.lightingTag,
    required this.gender,
  });

  factory Pose.fromJson(Map<String, dynamic> json) => Pose(
    poseId: json['pose_id'],
    poseImage: json['pose_image'],
    poseImageBase64: json['pose_image_base64'],
    description: json['description'],
    skeletonData: json['skeleton_data'],
    sceneTag: json['scene_tag'],
    lightingTag: json['lighting_tag'],
    gender: json['gender'],
  );
}

class PoseListResponse {
  final bool success;
  final List<Pose> poses;
  final String? error;

  PoseListResponse({required this.success, required this.poses, this.error});

  factory PoseListResponse.fromJson(Map<String, dynamic> json) => PoseListResponse(
    success: json['success'],
    poses: (json['data']['poses'] as List).map((e) => Pose.fromJson(e)).toList(),
    error: json['error'],
  );
}
