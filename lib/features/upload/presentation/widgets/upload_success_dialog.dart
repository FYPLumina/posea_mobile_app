import 'package:flutter/material.dart';

class UploadSuccessDialog extends StatelessWidget {
  final VoidCallback onViewPose;

  const UploadSuccessDialog({Key? key, required this.onViewPose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
              padding: const EdgeInsets.all(16),
              child: Icon(Icons.check, color: Colors.brown, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Upload Successfully',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'your screen has been analysed.\nwe found perfect poses for you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onViewPose,
                child: const Text('View pose', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
