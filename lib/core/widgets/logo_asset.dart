import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoAsset extends StatelessWidget {
  const LogoAsset({super.key, required this.assetPath, required this.width});

  final String assetPath;
  final double width;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString(assetPath),
      builder: (context, snapshot) {
        final svgText = snapshot.data;
        final base64Match = svgText == null
            ? null
            : RegExp(r'data:image\/png;base64,([A-Za-z0-9+/=]+)').firstMatch(svgText);

        if (base64Match != null) {
          final bytes = base64Decode(base64Match.group(1)!);
          return Image.memory(
            bytes,
            width: width,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          );
        }

        return SvgPicture.asset(assetPath, width: width, fit: BoxFit.contain);
      },
    );
  }
}
