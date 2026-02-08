import 'package:flutter/material.dart';

class WireframeCaptureScreen extends StatelessWidget {
  final VoidCallback onCapture;

  const WireframeCaptureScreen({Key? key, required this.onCapture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wireframe Capture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Show wireframe overlay and camera preview
            const Text('Align yourself with the wireframe.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              onPressed: onCapture,
              child: const Text('Capture', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
