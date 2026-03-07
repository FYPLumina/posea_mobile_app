import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class BodyMetrics {
  final double width;
  final double height;

  const BodyMetrics({required this.width, required this.height});
}

class SkeletonPlacement {
  final Offset center;
  final double width;
  final double height;

  const SkeletonPlacement({required this.center, required this.width, required this.height});
}

class PoseMatchResult {
  final int matchPercentage;
  final String instruction;

  const PoseMatchResult({required this.matchPercentage, required this.instruction});
}

class SequenceMatchResult {
  final int matchPercentage;
  final double averageJointError;

  const SequenceMatchResult({required this.matchPercentage, required this.averageJointError});
}

class PoseComparisonService {
  const PoseComparisonService();

  static const Map<int, String> _mediapipeIdToJoint = {
    0: 'nose',
    2: 'left_eye',
    5: 'right_eye',
    7: 'left_ear',
    8: 'right_ear',
    11: 'left_shoulder',
    12: 'right_shoulder',
    13: 'left_elbow',
    14: 'right_elbow',
    15: 'left_wrist',
    16: 'right_wrist',
    23: 'left_hip',
    24: 'right_hip',
    25: 'left_knee',
    26: 'right_knee',
    27: 'left_ankle',
    28: 'right_ankle',
  };

  static const List<List<String>> defaultConnections = [
    ['left_shoulder', 'right_shoulder'],
    ['left_shoulder', 'left_elbow'],
    ['left_elbow', 'left_wrist'],
    ['right_shoulder', 'right_elbow'],
    ['right_elbow', 'right_wrist'],
    ['left_shoulder', 'left_hip'],
    ['right_shoulder', 'right_hip'],
    ['left_hip', 'right_hip'],
    ['left_hip', 'left_knee'],
    ['left_knee', 'left_ankle'],
    ['right_hip', 'right_knee'],
    ['right_knee', 'right_ankle'],
  ];

  static Map<String, Offset> get defaultTargetSkeleton => {
    'nose': const Offset(0.5, 0.12),
    'left_shoulder': const Offset(0.42, 0.28),
    'right_shoulder': const Offset(0.58, 0.28),
    'left_elbow': const Offset(0.35, 0.44),
    'right_elbow': const Offset(0.65, 0.44),
    'left_wrist': const Offset(0.3, 0.62),
    'right_wrist': const Offset(0.7, 0.62),
    'left_hip': const Offset(0.44, 0.52),
    'right_hip': const Offset(0.56, 0.52),
    'left_knee': const Offset(0.44, 0.75),
    'right_knee': const Offset(0.56, 0.75),
    'left_ankle': const Offset(0.44, 0.94),
    'right_ankle': const Offset(0.56, 0.94),
  };

  Map<String, Offset> parseSkeletonData(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return {};
    }
    try {
      final dynamic decoded = jsonDecode(raw);
      final Map<String, Offset> parsed = _extractFromDynamic(decoded);
      return _normalizeToUnitBox(parsed);
    } catch (_) {
      return {};
    }
  }

  SkeletonPlacement? parseSkeletonPlacement(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    try {
      final dynamic decoded = jsonDecode(raw);
      final Map<String, Offset> parsed = _extractFromDynamic(decoded);
      if (parsed.isEmpty) {
        return null;
      }

      final xs = parsed.values.map((e) => e.dx).toList();
      final ys = parsed.values.map((e) => e.dy).toList();
      final minX = xs.reduce(math.min);
      final maxX = xs.reduce(math.max);
      final minY = ys.reduce(math.min);
      final maxY = ys.reduce(math.max);

      final allNormalized = minX >= 0 && maxX <= 1.0 && minY >= 0 && maxY <= 1.0;

      if (!allNormalized) {
        return null;
      }

      return SkeletonPlacement(
        center: Offset(((minX + maxX) / 2).clamp(0.15, 0.85), ((minY + maxY) / 2).clamp(0.1, 0.9)),
        width: (maxX - minX).abs(),
        height: (maxY - minY).abs(),
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, Offset> extractUserKeypoints(Pose pose) {
    final Map<String, PoseLandmarkType> keyMap = {
      'nose': PoseLandmarkType.nose,
      'left_eye': PoseLandmarkType.leftEye,
      'right_eye': PoseLandmarkType.rightEye,
      'left_ear': PoseLandmarkType.leftEar,
      'right_ear': PoseLandmarkType.rightEar,
      'left_shoulder': PoseLandmarkType.leftShoulder,
      'right_shoulder': PoseLandmarkType.rightShoulder,
      'left_elbow': PoseLandmarkType.leftElbow,
      'right_elbow': PoseLandmarkType.rightElbow,
      'left_wrist': PoseLandmarkType.leftWrist,
      'right_wrist': PoseLandmarkType.rightWrist,
      'left_hip': PoseLandmarkType.leftHip,
      'right_hip': PoseLandmarkType.rightHip,
      'left_knee': PoseLandmarkType.leftKnee,
      'right_knee': PoseLandmarkType.rightKnee,
      'left_ankle': PoseLandmarkType.leftAnkle,
      'right_ankle': PoseLandmarkType.rightAnkle,
    };

    final Map<String, Offset> points = {};
    for (final entry in keyMap.entries) {
      final landmark = pose.landmarks[entry.value];
      if (landmark != null) {
        points[entry.key] = Offset(landmark.x.toDouble(), landmark.y.toDouble());
      }
    }
    return _normalizeToUnitBox(points);
  }

  PoseMatchResult calculateFrameMatch({
    required Map<String, Offset> target,
    required Map<String, Offset> user,
  }) {
    final Set<String> common = target.keys.toSet().intersection(user.keys.toSet());
    if (common.length < 4) {
      return const PoseMatchResult(
        matchPercentage: 0,
        instruction: 'Keep your full body visible in the frame',
      );
    }

    double totalScore = 0;
    String? worstJoint;
    double worstDistance = -1;
    double worstDx = 0;
    double worstDy = 0;

    for (final joint in common) {
      final Offset t = target[joint]!;
      final Offset u = user[joint]!;
      final double dx = t.dx - u.dx;
      final double dy = t.dy - u.dy;
      final double distance = math.sqrt(dx * dx + dy * dy);
      final double score = (1 - (distance / 0.35)).clamp(0.0, 1.0);
      totalScore += score;

      if (distance > worstDistance) {
        worstDistance = distance;
        worstJoint = joint;
        worstDx = dx;
        worstDy = dy;
      }
    }

    final int percentage = ((totalScore / common.length) * 100).round().clamp(0, 100);
    final String instruction = _buildInstruction(
      percentage: percentage,
      joint: worstJoint,
      dx: worstDx,
      dy: worstDy,
    );

    return PoseMatchResult(matchPercentage: percentage, instruction: instruction);
  }

  SequenceMatchResult calculateSequenceMatch({
    required List<Map<String, Offset>> referenceFrames,
    required List<Map<String, Offset>> userFrames,
  }) {
    if (referenceFrames.isEmpty || userFrames.isEmpty) {
      return const SequenceMatchResult(matchPercentage: 0, averageJointError: 1.0);
    }

    final List<List<double>> dp = List.generate(
      referenceFrames.length + 1,
      (_) => List<double>.filled(userFrames.length + 1, double.infinity),
    );
    dp[0][0] = 0.0;

    for (int i = 1; i <= referenceFrames.length; i++) {
      for (int j = 1; j <= userFrames.length; j++) {
        final frameCost = _frameDistance(referenceFrames[i - 1], userFrames[j - 1]);
        final bestPrev = math.min(dp[i - 1][j], math.min(dp[i][j - 1], dp[i - 1][j - 1]));
        dp[i][j] = frameCost + bestPrev;
      }
    }

    final double pathLength = (referenceFrames.length + userFrames.length).toDouble();
    final double normalizedError = (dp[referenceFrames.length][userFrames.length] / pathLength)
        .clamp(0.0, 1.0);
    final int percentage = ((1 - normalizedError) * 100).round().clamp(0, 100);

    return SequenceMatchResult(matchPercentage: percentage, averageJointError: normalizedError);
  }

  BodyMetrics? extractBodyMetrics(
    Pose pose, {
    required double imageWidth,
    required double imageHeight,
  }) {
    if (imageWidth <= 0 || imageHeight <= 0) {
      return null;
    }

    const tracked = [
      PoseLandmarkType.nose,
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.rightHip,
      PoseLandmarkType.leftKnee,
      PoseLandmarkType.rightKnee,
      PoseLandmarkType.leftAnkle,
      PoseLandmarkType.rightAnkle,
    ];

    final points = <Offset>[];
    for (final type in tracked) {
      final landmark = pose.landmarks[type];
      if (landmark == null) {
        continue;
      }
      points.add(
        Offset(
          (landmark.x / imageWidth).clamp(0.0, 1.0),
          (landmark.y / imageHeight).clamp(0.0, 1.0),
        ),
      );
    }

    if (points.length < 4) {
      return null;
    }

    final minX = points.map((p) => p.dx).reduce(math.min);
    final maxX = points.map((p) => p.dx).reduce(math.max);
    final minY = points.map((p) => p.dy).reduce(math.min);
    final maxY = points.map((p) => p.dy).reduce(math.max);

    final width = ((maxX - minX).abs() * 1.12).clamp(0.05, 1.0);
    final height = ((maxY - minY).abs() * 1.08).clamp(0.08, 1.0);
    return BodyMetrics(width: width, height: height);
  }

  bool isLikelyHumanPose(Pose pose, {required double imageWidth, required double imageHeight}) {
    return humanPoseScore(pose, imageWidth: imageWidth, imageHeight: imageHeight) >= 0.70;
  }

  double humanPoseScore(Pose pose, {required double imageWidth, required double imageHeight}) {
    if (imageWidth <= 0 || imageHeight <= 0) {
      return 0.0;
    }

    final points = <String, Offset>{};
    final tracked = <String, PoseLandmarkType>{
      'nose': PoseLandmarkType.nose,
      'left_eye': PoseLandmarkType.leftEye,
      'right_eye': PoseLandmarkType.rightEye,
      'left_shoulder': PoseLandmarkType.leftShoulder,
      'right_shoulder': PoseLandmarkType.rightShoulder,
      'left_hip': PoseLandmarkType.leftHip,
      'right_hip': PoseLandmarkType.rightHip,
      'left_knee': PoseLandmarkType.leftKnee,
      'right_knee': PoseLandmarkType.rightKnee,
      'left_ankle': PoseLandmarkType.leftAnkle,
      'right_ankle': PoseLandmarkType.rightAnkle,
    };

    for (final entry in tracked.entries) {
      final landmark = pose.landmarks[entry.value];
      if (landmark == null) {
        continue;
      }
      points[entry.key] = Offset(
        (landmark.x / imageWidth).clamp(0.0, 1.0),
        (landmark.y / imageHeight).clamp(0.0, 1.0),
      );
    }

    return humanStructureScore(points);
  }

  bool isLikelyHumanStructure(Map<String, Offset> points) {
    return humanStructureScore(points) >= 0.70;
  }

  double humanStructureScore(Map<String, Offset> points) {
    final hasTorso =
        points['left_shoulder'] != null &&
        points['right_shoulder'] != null &&
        points['left_hip'] != null &&
        points['right_hip'] != null;
    final hasHead =
        points['nose'] != null || (points['left_eye'] != null && points['right_eye'] != null);
    final hasAtLeastOneLegChain =
        (points['left_knee'] != null && points['left_ankle'] != null) ||
        (points['right_knee'] != null && points['right_ankle'] != null);
    final hasAtLeastOneArmChain =
        (points['left_shoulder'] != null &&
            points['left_elbow'] != null &&
            points['left_wrist'] != null) ||
        (points['right_shoulder'] != null &&
            points['right_elbow'] != null &&
            points['right_wrist'] != null);

    if (!hasTorso || !hasHead || !hasAtLeastOneLegChain) {
      return 0.0;
    }

    double score = 0.35;
    if (hasAtLeastOneArmChain) {
      score += 0.10;
    }

    final shoulderCenterY = (points['left_shoulder']!.dy + points['right_shoulder']!.dy) / 2;
    final hipCenterY = (points['left_hip']!.dy + points['right_hip']!.dy) / 2;
    final torsoHeight = hipCenterY - shoulderCenterY;
    if (torsoHeight < 0.08) {
      return 0.0;
    }
    score += 0.12;

    final headY =
        points['nose']?.dy ??
        (((points['left_eye']?.dy ?? shoulderCenterY) +
                (points['right_eye']?.dy ?? shoulderCenterY)) /
            2);
    if (headY > shoulderCenterY - 0.02) {
      return 0.0;
    }
    score += 0.08;

    final shoulderWidth = (points['left_shoulder']!.dx - points['right_shoulder']!.dx).abs();
    final hipWidth = (points['left_hip']!.dx - points['right_hip']!.dx).abs();
    if (shoulderWidth < 0.04 || hipWidth < 0.03) {
      return 0.0;
    }
    score += 0.10;

    final all = points.values.toList();
    final minX = all.map((p) => p.dx).reduce(math.min);
    final maxX = all.map((p) => p.dx).reduce(math.max);
    final minY = all.map((p) => p.dy).reduce(math.min);
    final maxY = all.map((p) => p.dy).reduce(math.max);

    final width = (maxX - minX).abs();
    final height = (maxY - minY).abs();
    if (height < 0.24 || width < 0.06) {
      return 0.0;
    }

    final aspect = height / math.max(width, 1e-6);
    if (aspect < 1.15 || aspect > 5.0) {
      return 0.0;
    }
    score += 0.10;

    final leftChainValid = _isLegChainVertical(
      shoulder: points['left_shoulder'],
      hip: points['left_hip'],
      knee: points['left_knee'],
      ankle: points['left_ankle'],
    );
    final rightChainValid = _isLegChainVertical(
      shoulder: points['right_shoulder'],
      hip: points['right_hip'],
      knee: points['right_knee'],
      ankle: points['right_ankle'],
    );

    final legLengthRatio = _legToTorsoRatio(
      leftHip: points['left_hip'],
      leftKnee: points['left_knee'],
      leftAnkle: points['left_ankle'],
      rightHip: points['right_hip'],
      rightKnee: points['right_knee'],
      rightAnkle: points['right_ankle'],
      torsoHeight: torsoHeight,
    );
    if (legLengthRatio < 0.75) {
      return 0.0;
    }
    score += 0.15;

    if (leftChainValid || rightChainValid) {
      score += 0.10;
    }

    return score.clamp(0.0, 1.0);
  }

  List<List<String>> connectionsFor(Set<String> availableJoints) {
    return defaultConnections
        .where(
          (pair) =>
              pair.length == 2 &&
              availableJoints.contains(pair[0]) &&
              availableJoints.contains(pair[1]),
        )
        .toList();
  }

  bool _isLegChainVertical({
    required Offset? shoulder,
    required Offset? hip,
    required Offset? knee,
    required Offset? ankle,
  }) {
    if (shoulder == null || hip == null || knee == null || ankle == null) {
      return false;
    }
    return shoulder.dy < hip.dy - 0.03 && hip.dy < knee.dy - 0.015 && knee.dy < ankle.dy - 0.015;
  }

  double _legToTorsoRatio({
    required Offset? leftHip,
    required Offset? leftKnee,
    required Offset? leftAnkle,
    required Offset? rightHip,
    required Offset? rightKnee,
    required Offset? rightAnkle,
    required double torsoHeight,
  }) {
    final ratios = <double>[];

    final leftLength = _chainLength(leftHip, leftKnee, leftAnkle);
    if (leftLength != null && torsoHeight > 1e-6) {
      ratios.add(leftLength / torsoHeight);
    }

    final rightLength = _chainLength(rightHip, rightKnee, rightAnkle);
    if (rightLength != null && torsoHeight > 1e-6) {
      ratios.add(rightLength / torsoHeight);
    }

    if (ratios.isEmpty) {
      return 0.0;
    }

    return ratios.reduce((a, b) => a + b) / ratios.length;
  }

  double? _chainLength(Offset? a, Offset? b, Offset? c) {
    if (a == null || b == null || c == null) {
      return null;
    }
    return _distance(a, b) + _distance(b, c);
  }

  double _distance(Offset a, Offset b) {
    final dx = a.dx - b.dx;
    final dy = a.dy - b.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  double _frameDistance(Map<String, Offset> referenceFrame, Map<String, Offset> userFrame) {
    final Set<String> common = referenceFrame.keys.toSet().intersection(userFrame.keys.toSet());
    if (common.length < 4) {
      return 1.0;
    }

    double sumDistance = 0.0;
    for (final joint in common) {
      final ref = referenceFrame[joint]!;
      final usr = userFrame[joint]!;
      final dx = ref.dx - usr.dx;
      final dy = ref.dy - usr.dy;
      sumDistance += math.sqrt(dx * dx + dy * dy).clamp(0.0, 1.0);
    }

    return (sumDistance / common.length).clamp(0.0, 1.0);
  }

  String _buildInstruction({
    required int percentage,
    required String? joint,
    required double dx,
    required double dy,
  }) {
    if (percentage >= 80) {
      return 'Excellent! Hold this pose';
    }
    if (joint == null) {
      return 'Align your body with the target skeleton';
    }

    final String prettyJoint = joint.replaceAll('_', ' ');
    final List<String> movements = [];

    if (dx.abs() > 0.04) {
      movements.add(dx > 0 ? 'move right' : 'move left');
    }
    if (dy.abs() > 0.04) {
      movements.add(dy > 0 ? 'move down' : 'move up');
    }

    if (movements.isEmpty) {
      return 'Fine tune your posture and hold steady';
    }

    return 'Adjust $prettyJoint: ${movements.join(' and ')}';
  }

  Map<String, Offset> _extractFromDynamic(dynamic decoded) {
    final Map<String, Offset> points = {};

    if (decoded is List) {
      for (final item in decoded) {
        if (item is Map) {
          final dynamic rawId = item['id'];
          final int? id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
          final String? name = id != null
              ? (_mediapipeIdToJoint[id] ??
                    _normalizeJointName(item['name']?.toString() ?? item['key']?.toString()))
              : _normalizeJointName(
                  item['name']?.toString() ?? item['id']?.toString() ?? item['key']?.toString(),
                );
          final Offset? point = _offsetFromAny(item);
          if (name != null && point != null) {
            points[name] = point;
          }
        }
      }
      return points;
    }

    if (decoded is Map) {
      final dynamic candidates = decoded['keypoints'] ?? decoded['landmarks'] ?? decoded['points'];
      if (candidates != null) {
        points.addAll(_extractFromDynamic(candidates));
      }

      for (final entry in decoded.entries) {
        final String? key = _normalizeJointName(entry.key.toString());
        if (key == null) {
          continue;
        }
        final Offset? point = _offsetFromAny(entry.value);
        if (point != null) {
          points[key] = point;
        }
      }
    }

    return points;
  }

  Offset? _offsetFromAny(dynamic value) {
    if (value is Map) {
      final x = _toDouble(value['x'] ?? value['X'] ?? value['dx']);
      final y = _toDouble(value['y'] ?? value['Y'] ?? value['dy']);
      if (x != null && y != null) {
        return Offset(x, y);
      }
    }

    if (value is List && value.length >= 2) {
      final x = _toDouble(value[0]);
      final y = _toDouble(value[1]);
      if (x != null && y != null) {
        return Offset(x, y);
      }
    }
    return null;
  }

  double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  String? _normalizeJointName(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    final key = raw
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_')
        .replaceAll('left', 'left')
        .replaceAll('right', 'right');

    const aliases = {
      'leftshoulder': 'left_shoulder',
      'rightshoulder': 'right_shoulder',
      'leftelbow': 'left_elbow',
      'rightelbow': 'right_elbow',
      'leftwrist': 'left_wrist',
      'rightwrist': 'right_wrist',
      'lefthip': 'left_hip',
      'righthip': 'right_hip',
      'leftknee': 'left_knee',
      'rightknee': 'right_knee',
      'leftankle': 'left_ankle',
      'rightankle': 'right_ankle',
      'l_shoulder': 'left_shoulder',
      'r_shoulder': 'right_shoulder',
      'l_elbow': 'left_elbow',
      'r_elbow': 'right_elbow',
      'l_wrist': 'left_wrist',
      'r_wrist': 'right_wrist',
      'l_hip': 'left_hip',
      'r_hip': 'right_hip',
      'l_knee': 'left_knee',
      'r_knee': 'right_knee',
      'l_ankle': 'left_ankle',
      'r_ankle': 'right_ankle',
    };

    if (aliases.containsKey(key)) {
      return aliases[key];
    }

    return key;
  }

  Map<String, Offset> _normalizeToUnitBox(Map<String, Offset> raw) {
    if (raw.isEmpty) {
      return {};
    }

    final xs = raw.values.map((e) => e.dx).toList();
    final ys = raw.values.map((e) => e.dy).toList();
    final minX = xs.reduce(math.min);
    final maxX = xs.reduce(math.max);
    final minY = ys.reduce(math.min);
    final maxY = ys.reduce(math.max);

    final width = (maxX - minX).abs() < 1e-5 ? 1.0 : (maxX - minX);
    final height = (maxY - minY).abs() < 1e-5 ? 1.0 : (maxY - minY);

    return {
      for (final entry in raw.entries)
        entry.key: Offset((entry.value.dx - minX) / width, (entry.value.dy - minY) / height),
    };
  }
}
