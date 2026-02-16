import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'dart:convert';

import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:posea_mobile_app/features/poses/data/datasources/pose_image_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/repositories/pose_image_repository.dart';
import 'package:provider/provider.dart';

class PreviewPoseScreen extends StatelessWidget {
  const PreviewPoseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final map = state.extra is Map<String, dynamic> ? state.extra as Map<String, dynamic> : null;
    final String? base64Image = map?['base64Image'] as String?;
    final String? imageUrl = map?['imageUrl'] as String?;
    final String? poseId = map?['pose_id'] as String?;
    debugPrint('PreviewPoseScreen: pose_id = $poseId');
    // Debug prints
    debugPrint(
      'PreviewPoseScreen: base64Image length = \\${base64Image?.length}, startsWith data:image: \\${base64Image?.startsWith('data:image') ?? false}',
    );
    debugPrint('PreviewPoseScreen: imageUrl = \\${imageUrl ?? 'null'}');

    Widget imageWidget;
    if (base64Image != null && base64Image.isNotEmpty) {
      // Remove data:image/...;base64, prefix if present and strip whitespace/newlines
      String cleanedBase64 = base64Image;
      if (cleanedBase64.contains(',')) {
        cleanedBase64 = cleanedBase64.split(',').last;
      }
      cleanedBase64 = cleanedBase64.replaceAll(RegExp(r'\s+'), '');
      imageWidget = Image.memory(
        base64Decode(cleanedBase64),
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      imageWidget = const Center(child: Text('No pose image'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),

        title: const Text(
          'Preview pose',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done, color: Colors.black),
            onPressed: () async {
              final poseId = map?['pose_id'] as String?;
              final skeletonData = map?['skeletonData'];
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final accessToken = authProvider.token;
              if (poseId != null && accessToken != null) {
                final poseRepo = PoseImageRepository(apiService: PoseImageApiService());
                final success = await poseRepo.selectPose(poseId: poseId, accessToken: accessToken);
                if (success) {
                  debugPrint(
                    'PreviewPoseScreen: Navigating to wireframe-camera with pose_id = $poseId',
                  );
                  context.push(
                    '/wireframe-camera',
                    extra: {'skeletonData': skeletonData, 'pose_id': poseId, 'is_favourite': false},
                  );
                } else {
                  await AppFeedback.showErrorSheet('Failed to update pose');
                }
              } else {
                await AppFeedback.showErrorSheet('Missing pose_id or access token');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: Center(child: SizedBox.expand(child: imageWidget)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        items: [
          BottomNavItem(iconPath: 'assets/icons/home-outlined-icon.png', label: 'Home'),
          BottomNavItem(iconPath: 'assets/icons/gallery-outlined-icon.png', label: 'Gallery'),
          BottomNavItem(iconPath: 'assets/icons/camera.png', label: ''),
          BottomNavItem(iconPath: 'assets/icons/favourites-outlined-icon.png', label: 'Favourites'),
          BottomNavItem(iconPath: 'assets/icons/profile-outlined-icon.png', label: 'Profile'),
        ],
        currentIndex: 2,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.home);
              break;
            case 1:
              context.go(RouteNames.gallery);
              break;
            case 2:
              context.go(RouteNames.uploadBackground);
              break;
            case 3:
              context.go(RouteNames.favourites);
              break;
            case 4:
              context.go(RouteNames.profile);
              break;
          }
        },
      ),
    );
  }
}

// class _UploadBackgroundButton extends StatelessWidget {
//   const _UploadBackgroundButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFFC2B6AA),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           minimumSize: const Size.fromHeight(56),
//           elevation: 0,
//         ),
//         onPressed: () {
//           context.go(RouteNames.uploadBackground);
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(Icons.camera_alt, color: Color(0xFF6B4F36)),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'Upload New Background',
//                 style: TextStyle(
//                   color: Color(0xFF6B4F36),
//                   fontWeight: FontWeight.w600,
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, color: Color(0xFF6B4F36), size: 18),
//           ],
//         ),
//       ),
//     );
//   }
// }
