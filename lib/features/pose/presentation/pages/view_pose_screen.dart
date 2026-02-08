import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/features/poses/data/models/pose_model.dart';

class ViewPoseScreen extends StatelessWidget {
  final List<Pose> poses;

  const ViewPoseScreen({Key? key, required this.poses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Pose')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: poses.length,
        itemBuilder: (context, index) {
          final pose = poses[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: pose.poseImageBase64 != null
                  ? Image.memory(
                      base64Decode(
                        pose.poseImageBase64!.contains(',')
                            ? pose.poseImageBase64!.split(',').last
                            : pose.poseImageBase64!,
                      ),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      'http://<your_host>/static/${pose.poseImage}',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
              title: Text(pose.description ?? 'No description'),
              subtitle: Text(
                'Scene: ${pose.sceneTag ?? '-'} | Lighting: ${pose.lightingTag ?? '-'}',
              ),
              trailing: Text(pose.gender),
              onTap: () {
                final extraData = {
                  'pose_id': pose.poseId.toString(),
                  'description': pose.description,
                  'scene_tag': pose.sceneTag,
                  'lighting_tag': pose.lightingTag,
                  'gender': pose.gender,
                };
                if (pose.poseImageBase64 != null && pose.poseImageBase64!.isNotEmpty) {
                  context.push(
                    '/preview-pose',
                    extra: {...extraData, 'base64Image': pose.poseImageBase64},
                  );
                } else {
                  context.push(
                    '/preview-pose',
                    extra: {
                      ...extraData,
                      'imageUrl': 'http://<your_host>/static/${pose.poseImage}',
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
