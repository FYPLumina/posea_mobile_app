import 'package:flutter/material.dart';

class ViewPoseScreen extends StatelessWidget {
  final VoidCallback onSelectPose;

  const ViewPoseScreen({Key? key, required this.onSelectPose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Pose')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Here are your poses:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            // TODO: Replace with actual pose gallery
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              onPressed: onSelectPose,
              child: const Text('Select Pose', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
