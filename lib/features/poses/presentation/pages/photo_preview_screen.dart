import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/logger.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'dart:io';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:posea_mobile_app/features/poses/data/datasources/pose_image_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/repositories/pose_image_repository.dart';
import 'package:provider/provider.dart';

class PhotoPreviewScreen extends StatelessWidget {
  final String imagePath;
  const PhotoPreviewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'Photo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imagePath.isNotEmpty
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Image.network(
                      'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B4F36),
                      side: const BorderSide(color: Color(0xFF6B4F36)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(0, 48),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Retake',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4F36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(0, 48),
                    ),
                    onPressed: () async {
                      // Get pose_id and is_favourite from navigation arguments
                      final state = GoRouterState.of(context);
                      final args = state.extra is Map<String, dynamic>
                          ? state.extra as Map<String, dynamic>
                          : null;
                      String poseId = '';
                      bool isFavourite = false;
                      if (args != null) {
                        poseId = args['pose_id']?.toString() ?? '';
                        isFavourite = args['is_favourite'] ?? false;
                      }
                      AppLogger.debug(
                        'PhotoPreviewScreen: pose_id = ' +
                            poseId +
                            ', is_favourite = ' +
                            isFavourite.toString(),
                      );
                      if (poseId.isEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Missing pose_id')));
                        return;
                      }
                      // Encode image file to base64
                      try {
                        final file = File(imagePath);
                        final bytes = await file.readAsBytes();
                        final base64Image = 'data:image/png;base64,' + base64Encode(bytes);
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        final accessToken = authProvider.token;
                        if (accessToken == null) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('Missing access token')));
                          return;
                        }
                        final poseRepo = PoseImageRepository(apiService: PoseImageApiService());
                        final success = await poseRepo.captureImage(
                          capturedImageBase64: base64Image,
                          poseId: poseId,
                          isFavourite: isFavourite,
                          accessToken: accessToken,
                        );
                        if (success) {
                          await AppFeedback.showSuccessSheet(
                            'Image Saved',
                            'Your captured image has been saved successfully.',
                            actionText: 'Done',
                            onAction: () => context.go(RouteNames.home),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to save pose image')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
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
