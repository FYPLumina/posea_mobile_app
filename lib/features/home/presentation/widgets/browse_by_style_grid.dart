import 'package:flutter/material.dart';

class BrowseByStyleGrid extends StatelessWidget {
  const BrowseByStyleGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = [
      'assets/images/style1.jpg',
      'assets/images/style2.jpg',
      'assets/images/style3.jpg',
      'assets/images/style4.jpg',
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(images[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
