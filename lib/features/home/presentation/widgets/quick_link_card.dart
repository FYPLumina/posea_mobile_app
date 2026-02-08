import 'package:flutter/material.dart';

class QuickLinkCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;
  const QuickLinkCard({required this.title, required this.image, this.onTap, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 1,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(image, height: 230, width: double.infinity, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
