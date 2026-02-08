import 'package:flutter/material.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            final userName = context.select<AuthProvider, String>((auth) => auth.userName);
            return Text(
              'Hello, ${userName.isNotEmpty ? userName : 'User'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          },
        ),
        const SizedBox(height: 8),
        const Text('Ready for your next photo?', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
