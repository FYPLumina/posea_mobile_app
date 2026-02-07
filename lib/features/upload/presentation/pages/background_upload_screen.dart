import 'package:flutter/material.dart';

class BackgroundUploadScreen extends StatelessWidget {
  final String gender;
  final VoidCallback onUpload;

  const BackgroundUploadScreen({Key? key, required this.gender, required this.onUpload})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Background')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected gender: $gender', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              onPressed: onUpload,
              child: const Text(
                'Upload Background Image',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
