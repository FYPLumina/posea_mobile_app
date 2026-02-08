import 'package:flutter/material.dart';

class UploadFailedDialog extends StatelessWidget {
  final VoidCallback onTryAgain;
  final VoidCallback onNotNow;

  const UploadFailedDialog({Key? key, required this.onTryAgain, required this.onNotNow})
    : super(key: key);

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
              child: Icon(Icons.block, color: Colors.brown, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Upload Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Something went wrong while uploading your image. Please check your connection and try again.',
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
                onPressed: onTryAgain,
                child: const Text('Try Again', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onNotNow,
                child: const Text('Not Now', style: TextStyle(color: Colors.brown, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
