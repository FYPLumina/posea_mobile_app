import 'package:flutter/material.dart';

class SettingsOption {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  SettingsOption({required this.icon, required this.label, required this.onTap});
}

class SettingsOptionsCard extends StatelessWidget {
  final List<SettingsOption> options;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final double borderRadius;

  const SettingsOptionsCard({
    Key? key,
    required this.options,
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFF8B6F47),
    this.textColor = const Color(0xFF8B6F47),
    this.borderRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < options.length; i++) ...[
              ListTile(
                leading: Icon(options[i].icon, color: iconColor),
                title: Text(
                  options[i].label,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.chevron_right, color: iconColor),
                onTap: options[i].onTap,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                shape: i == 0
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
                      )
                    : i == options.length - 1
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
                      )
                    : null,
              ),
              if (i != options.length - 1)
                const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            ],
          ],
        ),
      ),
    );
  }
}
