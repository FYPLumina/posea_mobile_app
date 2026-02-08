class CapturedImage {
  final int capImageId;
  final String capturedImageBase64;
  final String userId;
  final bool isFavourite;
  final String capturedTime;
  final String poseId;

  CapturedImage({
    required this.capImageId,
    required this.capturedImageBase64,
    required this.userId,
    required this.isFavourite,
    required this.capturedTime,
    required this.poseId,
  });

  factory CapturedImage.fromJson(Map<String, dynamic> json) {
    return CapturedImage(
      capImageId: json['cap_image_id'],
      capturedImageBase64: json['captured_image_base64'],
      userId: json['user_id'].toString(),
      isFavourite: json['is_favourite'] is bool ? json['is_favourite'] : json['is_favourite'] == 1,
      capturedTime: json['captured_time'],
      poseId: json['pose_id'].toString(),
    );
  }
}
