import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({Key? key}) : super(key: key);

  ImageProvider? _profileImageProvider(String userImage) {
    final img = userImage.trim();
    if (img.isEmpty) {
      return null;
    }
    try {
      if (img.startsWith('data:image')) {
        final base64Str = img
            .substring(img.indexOf(',') + 1)
            .replaceAll('\n', '')
            .replaceAll(' ', '');
        return MemoryImage(base64Decode(base64Str));
      }
      return MemoryImage(base64Decode(img.replaceAll('\n', '').replaceAll(' ', '')));
    } catch (_) {
      return null;
    }
  }

  String _firstLetter(String userName) {
    final trimmed = userName.trim();
    if (trimmed.isEmpty) return 'U';
    return trimmed.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userName = context.select<AuthProvider, String>((auth) => auth.userName);
    final userImage = context.select<AuthProvider, String>((auth) => auth.userImage);
    final profileImage = _profileImageProvider(userImage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: profileImage,
              child: profileImage == null
                  ? Text(
                      _firstLetter(userName),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.helloUser(userName.isNotEmpty ? userName : l10n.user),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(l10n.readyForNextPhoto, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
