import 'package:flutter/material.dart';
import 'common_bottom_sheets.dart';

class CommonBottomSheetsDemo extends StatelessWidget {
  const CommonBottomSheetsDemo({super.key});

  void _showAllowPhotoAccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => buildAllowPhotoAccessSheet(
        onSettings: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Settings tapped')));
        },
        onNotNow: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Not Now tapped')));
        },
      ),
    );
  }

  void _showDeleteAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => buildDeleteAccountSheet(
        onDelete: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Delete Account tapped')));
        },
        onCancel: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Cancel tapped')));
        },
      ),
    );
  }

  void _showAccountCreatedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => buildAccountCreatedSheet(
        onGetStarted: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Get Started tapped')));
        },
        onClose: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => _showAllowPhotoAccessSheet(context),
          child: const Text('Show Allow Photo Access Sheet'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _showDeleteAccountSheet(context),
          child: const Text('Show Delete Account Sheet'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _showAccountCreatedSheet(context),
          child: const Text('Show Account Created Sheet'),
        ),
      ],
    );
  }
}
