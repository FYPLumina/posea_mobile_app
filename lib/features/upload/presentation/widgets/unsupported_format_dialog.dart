import 'package:flutter/material.dart';

class UnsupportedFormatDialog extends StatelessWidget {
  final VoidCallback onTryAnotherPhoto;

  const UnsupportedFormatDialog({Key? key, required this.onTryAnotherPhoto}) : super(key: key);

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
              'Unsupported Format',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "We can't upload this file. Please use a common photo format like JPG, PNG, or HEIC.",
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
                onPressed: onTryAnotherPhoto,
                child: const Text(
                  'Try Another photo',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
