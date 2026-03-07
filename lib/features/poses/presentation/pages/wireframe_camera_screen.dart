import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/utils/logger.dart';
import 'package:posea_mobile_app/features/poses/domain/services/pose_comparison_service.dart';

class WireframeCameraScreen extends StatefulWidget {
  final String? skeletonData;
  const WireframeCameraScreen({Key? key, this.skeletonData}) : super(key: key);

  @override
  State<WireframeCameraScreen> createState() => _WireframeCameraScreenState();
}

class _WireframeCameraScreenState extends State<WireframeCameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;

  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  bool _isProcessingFrame = false;
  bool _didLoadArgs = false;
  final PoseComparisonService _poseComparisonService = const PoseComparisonService();

  String? _skeletonData;
  String _poseIdLog = '';
  bool _isFavouriteLog = false;

  Map<String, Offset> _targetKeypoints = PoseComparisonService.defaultTargetSkeleton;
  List<List<String>> _targetConnections = PoseComparisonService.defaultConnections;
  int _matchPercentage = 0;
  double _skeletonWidthFactor = 0.45;
  double _skeletonHeightFactor = 0.85;
  double _baseSkeletonWidthFactor = 0.45;
  double _baseSkeletonHeightFactor = 0.85;
  String _distanceInstruction = 'Stand so your body size matches the skeleton';
  Offset _skeletonCenter = const Offset(0.5, 0.55);
  Offset _selectedPoseCenter = const Offset(0.5, 0.55);

  // For debugging: log received arguments when screen is opened and when capture button is pressed.
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

  // Load arguments passed via GoRouter when the screen is first opened.
  //This includes the skeleton data to match against, as well as logging info like pose_id and is_favourite for analytics.
  //We only want to load these once, so we guard with _didLoadArgs to prevent reloading if dependencies change.
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

      Pose? bestHumanPose;
      double bestHumanScore = 0.0;
      for (final pose in poses) {
        final score = _poseComparisonService.humanPoseScore(
          pose,
          imageWidth: image.width.toDouble(),
          imageHeight: image.height.toDouble(),
        );
        if (score > bestHumanScore) {
          bestHumanScore = score;
          bestHumanPose = pose;
        }
      }

      if (bestHumanPose == null || bestHumanScore < 0.70) {
        setState(() {
          _matchPercentage = 0;
          _distanceInstruction = 'No clear standing person found. Step away from objects and retry';
        });
        _isProcessingFrame = false;
        return;
      }

      final Map<String, Offset> userKeypoints = _poseComparisonService.extractUserKeypoints(
        bestHumanPose,
      );
      final BodyMetrics? bodyMetrics = _poseComparisonService.extractBodyMetrics(
        bestHumanPose,
        imageWidth: image.width.toDouble(),
        imageHeight: image.height.toDouble(),
      );
      final PoseMatchResult result = _poseComparisonService.calculateFrameMatch(
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
    final parsed = _poseComparisonService.parseSkeletonData(skeletonData);
    final placement = _poseComparisonService.parseSkeletonPlacement(skeletonData);
    setState(() {
      _targetKeypoints = parsed.isNotEmpty ? parsed : PoseComparisonService.defaultTargetSkeleton;
      _targetConnections = _poseComparisonService.connectionsFor(_targetKeypoints.keys.toSet());
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
  String _buildDistanceInstruction(BodyMetrics metrics) {
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
