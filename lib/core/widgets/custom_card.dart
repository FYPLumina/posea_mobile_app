import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconPath,
    this.onTap,
    this.backgroundColor = const Color(0xFFD4C4B0),
    this.iconBackgroundColor = const Color(0xFF8B6F47),
    this.iconColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.borderRadius = 30,
    this.showArrow = true,
    this.arrowColor = Colors.black,
  });

  final String title;
  final String subtitle;
  final String? iconPath;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final EdgeInsets padding;
  final double borderRadius;
  final bool showArrow;
  final Color arrowColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            // Icon
            if (iconPath != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(shape: BoxShape.circle, color: iconBackgroundColor),
                child: Center(child: _buildIcon(iconPath!)),
              ),
              const SizedBox(width: 16),
            ],
            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            if (showArrow) ...[
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward_ios, color: arrowColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String iconPath) {
    if (iconPath.endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    } else {
      return Image.asset(iconPath, width: 28, height: 28, color: iconColor);
    }
  }
}
