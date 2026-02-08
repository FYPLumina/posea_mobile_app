import 'package:flutter/material.dart';

class UploadingScreen extends StatelessWidget {
  const UploadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uploading')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Processing your background...', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            CircularProgressIndicator(color: Colors.brown),
          ],
        ),
      ),
    );
  }
}
