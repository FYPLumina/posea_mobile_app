import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconPath,
    this.backgroundColor = const Color(0xFF8B6F47),
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 48,
    this.iconSize = 24,
  });

  final String label;
  final VoidCallback onPressed;
  final String? iconPath;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (iconPath != null) ...[_buildIcon(iconPath!), const SizedBox(width: 16)],
            Text(
              label,
              style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String iconPath) {
    if (iconPath.endsWith('.svg')) {
      return SvgPicture.asset(iconPath, width: iconSize, height: iconSize);
    } else {
      return Image.asset(iconPath, width: iconSize, height: iconSize);
    }
  }
}
