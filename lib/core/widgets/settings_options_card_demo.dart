import 'package:flutter/material.dart';
import 'settings_options_card.dart';

class SettingsOptionsCardDemo extends StatelessWidget {
  const SettingsOptionsCardDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings Options Card Demo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SettingsOptionsCard(
            options: [
              SettingsOption(
                icon: Icons.lock_outline,
                label: 'Change password',
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Change password tapped'))),
              ),
              SettingsOption(
                icon: Icons.language,
                label: 'Language',
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Language tapped'))),
              ),
              SettingsOption(
                icon: Icons.delete_outline,
                label: 'Delete Account',
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Delete Account tapped'))),
              ),
              SettingsOption(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Privacy Policy tapped'))),
              ),
              SettingsOption(
                icon: Icons.logout,
                label: 'Log Out',
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Log Out tapped'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
