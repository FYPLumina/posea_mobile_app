import 'package:flutter/material.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onCancel;

  const LogoutDialog({Key? key, required this.onLogout, required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              child: Icon(Icons.logout, color: Colors.brown, size: 40),
            ),
            const SizedBox(height: 24),
            Text(l10n.logOutQuestion, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              l10n.logOutDescription,
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
                onPressed: onLogout,
                child: Text(l10n.logOut, style: TextStyle(color: Colors.white, fontSize: 16)),
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
                onPressed: onCancel,
                child: Text(l10n.cancel, style: TextStyle(color: Colors.brown, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
