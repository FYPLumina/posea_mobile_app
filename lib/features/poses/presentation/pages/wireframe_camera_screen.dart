import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class WireframeCameraScreen extends StatefulWidget {
  const WireframeCameraScreen({Key? key}) : super(key: key);

  @override
  State<WireframeCameraScreen> createState() => _WireframeCameraScreenState();
}

class _WireframeCameraScreenState extends State<WireframeCameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      setState(() {
        _isCameraReady = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => Navigator.of(context).pop(),
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Align your body within the white wireframe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
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
                  CustomPaint(size: const Size(200, 400), painter: _PoseWireframePainter()),
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
                            await _controller!.takePicture();
                            // TODO: Handle picture
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
}

class _PoseWireframePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    // Example skeleton points (mock pose)
    final points = [
      Offset(size.width * 0.5, size.height * 0.1), // head
      Offset(size.width * 0.5, size.height * 0.2), // neck
      Offset(size.width * 0.4, size.height * 0.3), // left shoulder
      Offset(size.width * 0.6, size.height * 0.3), // right shoulder
      Offset(size.width * 0.35, size.height * 0.5), // left elbow
      Offset(size.width * 0.65, size.height * 0.5), // right elbow
      Offset(size.width * 0.3, size.height * 0.7), // left wrist
      Offset(size.width * 0.7, size.height * 0.7), // right wrist
      Offset(size.width * 0.5, size.height * 0.4), // chest
      Offset(size.width * 0.5, size.height * 0.6), // hip
      Offset(size.width * 0.4, size.height * 0.8), // left knee
      Offset(size.width * 0.6, size.height * 0.8), // right knee
      Offset(size.width * 0.4, size.height * 0.95), // left ankle
      Offset(size.width * 0.6, size.height * 0.95), // right ankle
    ];

    // Draw lines (mock connections)
    final connections = [
      [0, 1],
      [1, 2],
      [1, 3],
      [2, 4],
      [3, 5],
      [4, 6],
      [5, 7],
      [1, 8],
      [8, 9],
      [9, 10],
      [9, 11],
      [10, 12],
      [11, 13],
    ];
    for (var pair in connections) {
      canvas.drawLine(points[pair[0]], points[pair[1]], paint);
    }
    // Draw dots
    for (var point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
