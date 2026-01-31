import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.width = double.infinity,
    this.backgroundColor = const Color(0xFF8B6F47),
    this.textColor = Colors.white,
    this.borderColor,
    this.isBordered = false,
    this.height = 50,
  });

  final VoidCallback onPressed;
  final String label;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final bool isBordered;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: isBordered
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor ?? Colors.black, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                label,
                style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                label,
                style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
    );
  }
}
