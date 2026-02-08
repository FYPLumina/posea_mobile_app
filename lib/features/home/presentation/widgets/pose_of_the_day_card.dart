import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:posea_mobile_app/features/home/application/pose_of_the_day_provider.dart';
import 'dart:convert';

class PoseOfTheDayCard extends StatelessWidget {
  const PoseOfTheDayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PoseOfTheDayProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
        }
        if (provider.error != null) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: SizedBox(
              height: 300,
              child: Center(
                child: Text(provider.error!, style: TextStyle(color: Colors.red)),
              ),
            ),
          );
        }
        final pose = provider.pose;
        Widget imageWidget;
        if (pose != null) {
          if (pose.poseImageBase64 != null && pose.poseImageBase64!.isNotEmpty) {
            String base64Str = pose.poseImageBase64!;
            // Remove data URL prefix if present
            final dataUrlPrefix = 'data:image';
            if (base64Str.startsWith(dataUrlPrefix)) {
              final commaIdx = base64Str.indexOf(',');
              if (commaIdx != -1) {
                base64Str = base64Str.substring(commaIdx + 1);
              }
            }
            imageWidget = Image.memory(
              base64Decode(base64Str),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          } else {
            imageWidget = Image.asset(
              'assets/images/pose-of-the-day-sample-image.png',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          }
        } else {
          imageWidget = Image.asset(
            'assets/images/pose-of-the-day-sample-image.png',
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        }
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Stack(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(16), child: imageWidget),
              Positioned(
                left: 16,
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Pose of the Day',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      backgroundColor: const Color.fromARGB(255, 179, 116, 57),
                      onPressed: () {
                        final pose = provider.pose;
                        if (pose != null) {
                          final map = {
                            'pose_id': pose.poseId.toString(),
                            'base64Image': pose.poseImageBase64 ?? '',
                            'imageUrl': pose.poseImage,
                            'description': pose.description,
                            'scene_tag': pose.sceneTag,
                            'lighting_tag': pose.lightingTag,
                            'gender': pose.gender,
                            'skeletonData': pose.skeletonData,
                          };
                          debugPrint(
                            'PoseOfTheDayCard: Navigating to preview-pose with pose_id = ${map['pose_id']}',
                          );
                          context.push('/preview-pose', extra: map);
                        }
                      },
                      label: 'Try this pose',
                      width: 150,
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
