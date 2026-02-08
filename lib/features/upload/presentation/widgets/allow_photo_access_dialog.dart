import 'package:flutter/material.dart';

class AllowPhotoAccessDialog extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback onNotNow;

  const AllowPhotoAccessDialog({Key? key, required this.onSettings, required this.onNotNow})
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
              child: Icon(Icons.camera_alt, color: Colors.brown, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Allow Photo Access?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'To upload or take photos for your backgrounds, we need access to your gallery and camera. This helps personalize your experience.',
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
                onPressed: onSettings,
                child: const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 16)),
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
