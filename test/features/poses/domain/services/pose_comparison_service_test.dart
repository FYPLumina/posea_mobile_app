import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posea_mobile_app/features/poses/domain/services/pose_comparison_service.dart';

void main() {
  const service = PoseComparisonService();

  group('PoseComparisonService', () {
    test('parseSkeletonData handles list-based skeleton JSON', () {
      const json = '''
      [
        {"id": 11, "x": 10, "y": 20},
        {"id": 12, "x": 30, "y": 20},
        {"id": 23, "x": 12, "y": 50},
        {"id": 24, "x": 28, "y": 50}
      ]
      ''';

      final result = service.parseSkeletonData(json);

      expect(
        result.keys,
        containsAll(['left_shoulder', 'right_shoulder', 'left_hip', 'right_hip']),
      );
      expect(result.values.every((p) => p.dx >= 0 && p.dx <= 1), isTrue);
      expect(result.values.every((p) => p.dy >= 0 && p.dy <= 1), isTrue);
    });

    test('calculateFrameMatch returns 100 for identical keypoints', () {
      final target = {
        'left_shoulder': const Offset(0.25, 0.2),
        'right_shoulder': const Offset(0.75, 0.2),
        'left_hip': const Offset(0.3, 0.55),
        'right_hip': const Offset(0.7, 0.55),
      };

      final result = service.calculateFrameMatch(target: target, user: target);

      expect(result.matchPercentage, 100);
    });

    test('calculateSequenceMatch scores high for similar sequences', () {
      final referenceFrames = [
        {
          'left_shoulder': const Offset(0.25, 0.2),
          'right_shoulder': const Offset(0.75, 0.2),
          'left_hip': const Offset(0.3, 0.55),
          'right_hip': const Offset(0.7, 0.55),
        },
        {
          'left_shoulder': const Offset(0.26, 0.2),
          'right_shoulder': const Offset(0.74, 0.2),
          'left_hip': const Offset(0.31, 0.56),
          'right_hip': const Offset(0.69, 0.56),
        },
      ];

      final userFrames = [
        {
          'left_shoulder': const Offset(0.27, 0.22),
          'right_shoulder': const Offset(0.73, 0.22),
          'left_hip': const Offset(0.32, 0.57),
          'right_hip': const Offset(0.68, 0.57),
        },
        {
          'left_shoulder': const Offset(0.26, 0.21),
          'right_shoulder': const Offset(0.74, 0.21),
          'left_hip': const Offset(0.3, 0.55),
          'right_hip': const Offset(0.7, 0.55),
        },
      ];

      final result = service.calculateSequenceMatch(
        referenceFrames: referenceFrames,
        userFrames: userFrames,
      );

      expect(result.matchPercentage, greaterThan(80));
      expect(result.averageJointError, lessThan(0.2));
    });

    test('isLikelyHumanStructure returns true for human-like body layout', () {
      final points = {
        'nose': const Offset(0.5, 0.16),
        'left_elbow': const Offset(0.36, 0.4),
        'right_elbow': const Offset(0.64, 0.41),
        'left_wrist': const Offset(0.34, 0.53),
        'right_wrist': const Offset(0.66, 0.54),
        'left_shoulder': const Offset(0.42, 0.28),
        'right_shoulder': const Offset(0.58, 0.29),
        'left_hip': const Offset(0.44, 0.5),
        'right_hip': const Offset(0.56, 0.5),
        'left_knee': const Offset(0.45, 0.72),
        'right_knee': const Offset(0.55, 0.73),
        'left_ankle': const Offset(0.45, 0.9),
        'right_ankle': const Offset(0.55, 0.9),
      };

      expect(service.isLikelyHumanStructure(points), isTrue);
      expect(service.humanStructureScore(points), greaterThanOrEqualTo(0.7));
    });

    test('isLikelyHumanStructure returns false for chair-like rigid shape', () {
      final points = {
        'left_shoulder': const Offset(0.4, 0.45),
        'right_shoulder': const Offset(0.6, 0.45),
        'left_hip': const Offset(0.42, 0.5),
        'right_hip': const Offset(0.58, 0.5),
        'left_knee': const Offset(0.38, 0.46),
        'right_knee': const Offset(0.62, 0.46),
        'left_ankle': const Offset(0.38, 0.48),
        'right_ankle': const Offset(0.62, 0.48),
      };

      expect(service.isLikelyHumanStructure(points), isFalse);
      expect(service.humanStructureScore(points), lessThan(0.7));
    });
  });
}
