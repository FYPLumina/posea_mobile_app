import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/utils/logger.dart';

// This screen implements a wireframe camera view that guides users to match their body pose to a target skeleton. 
//It uses the device camera and ML Kit's pose detection to analyze the user's posture in real-time, providing feedback on how closely they match the target pose and instructions on how to adjust their position for a better match. The target skeleton can be customized via JSON data passed as an argument when navigating to this screen.
class WireframeCameraScreen extends StatefulWidget {
  final String? skeletonData;
  const WireframeCameraScreen({Key? key, this.skeletonData}) : super(key: key);

// The createState method creates the mutable state for this screen, which will manage the camera feed, pose detection, and UI updates based on the user's pose matching against the target skeleton.
  @override
  State<WireframeCameraScreen> createState() => _WireframeCameraScreenState();
}
// The state class for the WireframeCameraScreen manages the camera controller, pose detection, and the logic for comparing the user's pose to the target skeleton. for the user's pose to the targret skeleton.
class _WireframeCameraScreenState extends State<WireframeCameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;

  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  bool _isProcessingFrame = false;
  bool _didLoadArgs = false;

  String? _skeletonData;
  String _poseIdLog = '';
  bool _isFavouriteLog = false;

  Map<String, Offset> _targetKeypoints = _PoseMatcher.defaultTargetSkeleton;
  List<List<String>> _targetConnections = _PoseMatcher.defaultConnections;
  int _matchPercentage = 0;
  double _skeletonWidthFactor = 0.45;
  double _skeletonHeightFactor = 0.85;
  double _baseSkeletonWidthFactor = 0.45;
  double _baseSkeletonHeightFactor = 0.85;
  String _distanceInstruction = 'Stand so your body size matches the skeleton';
  Offset _skeletonCenter = const Offset(0.5, 0.55);
  Offset _selectedPoseCenter = const Offset(0.5, 0.55);

// The initState method is called when the screen is first created. 
//It initializes the camera by fetching the available cameras and setting up the camera controller to start streaming images for pose detection. 
  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );
      await _controller!.initialize();
      await _controller!.startImageStream(_processCameraImage);
      setState(() {
        _isCameraReady = true;
      });
    }
  }

// The didChangeDependencies method is called after initState and whenever the dependencies of the state change.
// It checks if the screen has already loaded its arguments to avoid redundant processing. If not,
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoadArgs) {
      return;
    }
    _didLoadArgs = true;

    final state = GoRouterState.of(context);
    final args = state.extra is Map<String, dynamic> ? state.extra as Map<String, dynamic> : null;
    if (args != null) {
      _poseIdLog = args['pose_id']?.toString() ?? '';
      _isFavouriteLog = args['is_favourite'] == true;
      if (widget.skeletonData == null && args['skeletonData'] is String) {
        _skeletonData = args['skeletonData'] as String;
      }
    }
    _skeletonData ??= widget.skeletonData;
    _setTargetSkeleton(_skeletonData);

    debugPrint(
      'WireframeCameraScreen: received pose_id = $_poseIdLog, is_favourite = $_isFavouriteLog',
    );
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessingFrame || !_isCameraReady || _controller == null) {
      return;
    }
    _isProcessingFrame = true;

    try {
      final InputImage? inputImage = _toInputImage(image, _controller!.description);
      if (inputImage == null) {
        _isProcessingFrame = false;
        return;
      }

      final List<Pose> poses = await _poseDetector.processImage(inputImage);
      if (!mounted) {
        _isProcessingFrame = false;
        return;
      }

      if (poses.isEmpty) {
        setState(() {
          _matchPercentage = 0;
          _distanceInstruction = 'Step into frame until your full body is visible';
        });
        _isProcessingFrame = false;
        return;
      }

      final Map<String, Offset> userKeypoints = _PoseMatcher.extractUserKeypoints(poses.first);
      final _BodyMetrics? bodyMetrics = _PoseMatcher.extractBodyMetrics(
        poses.first,
        imageWidth: image.width.toDouble(),
        imageHeight: image.height.toDouble(),
      );
      final _PoseMatchResult result = _PoseMatcher.calculateMatch(
        target: _targetKeypoints,
        user: userKeypoints,
      );

      final bool shouldUpdateMatch = (_matchPercentage - result.matchPercentage).abs() >= 1;
      final String distanceInstruction = bodyMetrics == null
          ? 'Keep your full body visible in frame'
          : _buildDistanceInstruction(bodyMetrics);
      final bool shouldUpdateDistanceInstruction = _distanceInstruction != distanceInstruction;

      if (shouldUpdateMatch || shouldUpdateDistanceInstruction) {
        setState(() {
          if (shouldUpdateMatch) {
            _matchPercentage = result.matchPercentage;
          }
          _distanceInstruction = distanceInstruction;
        });
      }
    } catch (_) {
      // Keep camera flow resilient when a frame fails.
    }

    _isProcessingFrame = false;
  }

  InputImage? _toInputImage(CameraImage image, CameraDescription cameraDescription) {
    final InputImageRotation? rotation = InputImageRotationValue.fromRawValue(
      cameraDescription.sensorOrientation,
    );
    if (rotation == null || image.planes.isEmpty) {
      return null;
    }

    final Uint8List bytes = Uint8List.fromList(
      image.planes.expand((Plane plane) => plane.bytes).toList(),
    );

    final InputImageFormat format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

// Parses the skeleton data from the provided JSON string, extracts keypoints and their placements, and updates the target skeleton and UI state accordingly. If placement info is included, it adjusts the skeleton's position and size on screen to match the intended pose layout.
  void _setTargetSkeleton(String? skeletonData) {
    final parsed = _PoseMatcher.parseSkeletonData(skeletonData);
    final placement = _PoseMatcher.parseSkeletonPlacement(skeletonData);
    setState(() {
      _targetKeypoints = parsed.isNotEmpty ? parsed : _PoseMatcher.defaultTargetSkeleton;
      _targetConnections = _PoseMatcher.connectionsFor(_targetKeypoints.keys.toSet());
      if (placement != null) {
        _selectedPoseCenter = placement.center;
        _skeletonCenter = placement.center;
        _skeletonWidthFactor = placement.width.clamp(0.25, 0.92);
        _skeletonHeightFactor = placement.height.clamp(0.35, 0.98);
        _baseSkeletonWidthFactor = _skeletonWidthFactor;
        _baseSkeletonHeightFactor = _skeletonHeightFactor;
      } else {
        _selectedPoseCenter = const Offset(0.5, 0.55);
        _skeletonCenter = _selectedPoseCenter;
        _baseSkeletonWidthFactor = _skeletonWidthFactor;
        _baseSkeletonHeightFactor = _skeletonHeightFactor;
      }
      _distanceInstruction = 'Stand so your body size matches the skeleton';
    });
  }

// Clean up resources when the screen is disposed. Stop the camera stream if active, close the pose detector, and dispose the camera controller to free up memory and avoid leaks.
  @override
  void dispose() {
    if (_controller?.value.isStreamingImages == true) {
      _controller?.stopImageStream();
    }
    _poseDetector.close();
    _controller?.dispose();
    super.dispose();
  }

// Build the UI for the wireframe camera screen. This includes a header with a close button and title, an instruction box showing the current match percentage and distance guidance, the camera preview with a custom painter overlay to draw the target skeleton, and a capture button at the bottom.
// The skeleton color changes to green when the user achieves a good match (90% or above) to provide visual feedback.
  @override
  Widget build(BuildContext context) {
    final bool isMatched = _matchPercentage >= 80;
    final Color skeletonColor = isMatched ? Colors.green : Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    'Wireframe',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for symmetry
                ],
              ),
            ),
            // Instruction
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Text(
                        'Match: $_matchPercentage%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _distanceInstruction,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Camera preview with wireframe overlay
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _isCameraReady && _controller != null
                        ? CameraPreview(_controller!)
                        : Container(
                            color: Colors.black12,
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _PoseWireframePainter(
                        points: _targetKeypoints,
                        connections: _targetConnections,
                        color: skeletonColor,
                        center: _skeletonCenter,
                        widthFactor: _skeletonWidthFactor,
                        heightFactor: _skeletonHeightFactor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Capture button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFC2B6AA),
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Color(0xFF6B4F36)),
                    onPressed: _isCameraReady && _controller != null
                        ? () async {
                            final XFile file = await _controller!.takePicture();
                            if (context.mounted) {
                              AppLogger.debug(
                                'WireframeCameraScreen: Passing to photo-preview -> pose_id: $_poseIdLog, is_favourite: $_isFavouriteLog',
                              );
                              context.push(
                                '/photo-preview',
                                extra: {
                                  'imagePath': file.path,
                                  'pose_id': _poseIdLog,
                                  'is_favourite': _isFavouriteLog,
                                },
                              );
                            }
                          }
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
// Helper method to build distance instruction based on user's body metrics compared to target skeleton size.
// It calculates a ratio of user's body width and height to the target skeleton's dimensions, and provides feedback on whether to move closer or further from the camera, along with an estimated distance in centimeters.
  String _buildDistanceInstruction(_BodyMetrics metrics) {
    final targetHeight = _baseSkeletonHeightFactor.clamp(0.20, 0.99);
    final targetWidth = _baseSkeletonWidthFactor.clamp(0.15, 0.95);
    final heightRatio = metrics.height / targetHeight;
    final widthRatio = metrics.width / targetWidth;
    final ratio = (heightRatio * 0.7) + (widthRatio * 0.3);

    if (ratio > 1.05) {
      final meters = (((ratio - 1.0) * 1.0).clamp(0.1, 2.0));
      final cm = (meters * 100).round();
      return 'Move back about $cm cm';
    }
    if (ratio < 0.95) {
      final meters = (((1.0 / ratio) - 1.0) * 1.0).clamp(0.1, 2.0);
      final cm = (meters * 100).round();
      return 'Move closer about $cm cm';
    }

    return 'Perfect distance. Hold this position';
  }
}

// Custom painter to draw the target skeleton wireframe on top of the camera preview.
// It takes the target keypoints and connections, as well as styling parameters like color and size factors, and renders lines between connected joints and dots at each joint position.
// The keypoints are normalized and scaled to fit within the defined skeleton area on screen.
class _PoseWireframePainter extends CustomPainter {
  final Map<String, Offset> points;
  final List<List<String>> connections;
  final Color color;
  final Offset center;
  final double widthFactor;
  final double heightFactor;

  _PoseWireframePainter({
    required this.points,
    required this.connections,
    required this.color,
    required this.center,
    required this.widthFactor,
    required this.heightFactor,
  });

// The paint method is called to render the skeleton wireframe on the canvas. 
//It calculates the bounding box of the keypoints to determine how to scale and position them within the defined skeleton area.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    final xs = points.values.map((e) => e.dx).toList();
    final ys = points.values.map((e) => e.dy).toList();
    final minX = xs.reduce(math.min);
    final maxX = xs.reduce(math.max);
    final minY = ys.reduce(math.min);
    final maxY = ys.reduce(math.max);
    final spanX = (maxX - minX).abs() < 1e-6 ? 1.0 : (maxX - minX);
    final spanY = (maxY - minY).abs() < 1e-6 ? 1.0 : (maxY - minY);

    final left = center.dx - (widthFactor / 2);
    final top = center.dy - (heightFactor / 2);

    final Map<String, Offset> scaled = {
      for (final entry in points.entries)
        entry.key: Offset(
          ((left + ((entry.value.dx - minX) / spanX) * widthFactor).clamp(0.0, 1.0)) * size.width,
          ((top + ((entry.value.dy - minY) / spanY) * heightFactor).clamp(0.0, 1.0)) * size.height,
        ),
    };

    for (final pair in connections) {
      if (pair.length != 2) {
        continue;
      }
      final p1 = scaled[pair[0]];
      final p2 = scaled[pair[1]];
      if (p1 == null || p2 == null) {
        continue;
      }
      canvas.drawLine(p1, p2, paint);
    }

    for (final point in scaled.values) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

// Determines whether the painter should repaint when the widget is updated.
// It compares the current properties with the old ones, and returns true if any of the key properties (color, points, connections, center, widthFactor, heightFactor) have changed, indicating that the skeleton wireframe needs to be redrawn with new data or styling.
  @override
  bool shouldRepaint(covariant _PoseWireframePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.points != points ||
        oldDelegate.connections != connections ||
        oldDelegate.center != center ||
        oldDelegate.widthFactor != widthFactor ||
        oldDelegate.heightFactor != heightFactor;
  }
}

class _BodyMetrics {
  final double width;
  final double height;

  const _BodyMetrics({required this.width, required this.height});
}

class _SkeletonPlacement {
  final Offset center;
  final double width;
  final double height;

  const _SkeletonPlacement({required this.center, required this.width, required this.height});
}

class _PoseMatchResult {
  final int matchPercentage;
  final String instruction;

  const _PoseMatchResult({required this.matchPercentage, required this.instruction});
}

class _PoseMatcher {
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

  static Map<String, Offset> parseSkeletonData(String? raw) {
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

  static _SkeletonPlacement? parseSkeletonPlacement(String? raw) {
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

      if (allNormalized) {
        return _SkeletonPlacement(
          center: Offset(
            ((minX + maxX) / 2).clamp(0.15, 0.85),
            ((minY + maxY) / 2).clamp(0.1, 0.9),
          ),
          width: (maxX - minX).abs(),
          height: (maxY - minY).abs(),
        );
      }

      return null;
    } catch (_) {
      return null;
    }
  }

// Normalizes the keypoints to fit within a unit box (0 to 1 range) based on the bounding box of the provided points.

  static Map<String, Offset> extractUserKeypoints(Pose pose) {
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

// Normalizes the provided keypoints to fit within a unit box (0 to 1 range) based on the bounding box of the points. This ensures that the pose matching is scale-invariant and focuses on the relative positions of joints rather than their absolute coordinates.
  static _PoseMatchResult calculateMatch({
    required Map<String, Offset> target,
    required Map<String, Offset> user,
  }) {
    final Set<String> common = target.keys.toSet().intersection(user.keys.toSet());
    if (common.length < 4) {
      return const _PoseMatchResult(
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

    return _PoseMatchResult(matchPercentage: percentage, instruction: instruction);
  }

// bodyMetrics extraction method calculates the width and height of the user's detected pose based on the bounding box of key landmarks. 
//It normalizes these dimensions by the image size to provide a scale-invariant measure of the user's body size, which can be used to give feedback on whether they are too close or too far from the camera compared to the target skeleton.
  static _BodyMetrics? extractBodyMetrics(
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
    return _BodyMetrics(width: width, height: height);
  }

// Builds an instruction string based on the user's current match percentage to the target pose, the joint that is furthest off, and the direction they need to adjust to improve their match. 
//It provides specific feedback on which joint to focus on and whether to move up/down or left/right to better align with the target skeleton.
  static String _buildInstruction({
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

// Extracts keypoints from a dynamic decoded JSON structure, supporting various formats such as lists of keypoint objects or maps with keypoint data.
// It normalizes joint names and coordinates to create a consistent mapping of joint names to their corresponding 2D positions, which can then be used for pose matching against the target skeleton.
  static Map<String, Offset> _extractFromDynamic(dynamic decoded) {
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

// Helper method to extract an Offset from a dynamic value that may represent a point in various formats, such as a map with 'x' and 'y' keys or a list with two elements.
  static Offset? _offsetFromAny(dynamic value) {
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

// Helper method to convert a dynamic value to a double, supporting both numeric types and strings that can be parsed as doubles. 
//This is used to handle various formats of coordinate data in the input skeleton data.
  static double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

// Normalizes joint names by trimming whitespace, converting to lowercase, replacing common separators with underscores, and mapping known aliases to standard joint names.
  static String? _normalizeJointName(String? raw) {
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


  static Map<String, Offset> _normalizeToUnitBox(Map<String, Offset> raw) {
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
// Filters the default connections to include only those pairs of joints that are present in the provided set of available joints. 
//This ensures that the wireframe overlay only attempts to draw connections between joints that are actually detected and available in the target skeleton, preventing errors and improving visual clarity.
  static List<List<String>> connectionsFor(Set<String> availableJoints) {
    return defaultConnections
        .where(
          (pair) =>
              pair.length == 2 &&
              availableJoints.contains(pair[0]) &&
              availableJoints.contains(pair[1]),
        )
        .toList();
  }
}
