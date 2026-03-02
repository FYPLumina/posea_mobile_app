import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/features/pose/presentation/pages/view_pose_screen.dart';
import 'package:posea_mobile_app/features/poses/data/datasources/pose_image_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/repositories/pose_image_repository.dart';
import 'package:provider/provider.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';

class UploadBackgroundScreen extends StatefulWidget {
  const UploadBackgroundScreen({Key? key}) : super(key: key);

  @override
  State<UploadBackgroundScreen> createState() => _UploadBackgroundScreenState();
}

class _UploadBackgroundScreenState extends State<UploadBackgroundScreen> {
  bool _loading = false;

  Future<void> _handleUpload(BuildContext context, {required bool fromCamera}) async {
    setState(() => _loading = true);
    try {
      final picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );
      if (pickedFile == null) {
        await AppFeedback.showErrorSheet('No image selected');
        return;
      }
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      // Get access token from AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final accessToken = authProvider.token;
      if (accessToken == null) {
        await AppFeedback.showErrorSheet('User not authenticated');
        return;
      }

      final poseRepo = PoseImageRepository(apiService: PoseImageApiService());
      final poses = await poseRepo.suggestPoses(imageBase64: base64Image, accessToken: accessToken);
      if (poses != null) {
        if (!mounted) return;
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewPoseScreen(poses: poses)));
      } else {
        await AppFeedback.showErrorSheet('Failed to get suggested poses');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF8F7F5),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Upload Background',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC2B6AA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 48, color: Color(0xFF6B4F36)),
                        SizedBox(height: 12),
                        Text(
                          'Upload background',
                          style: TextStyle(
                            color: Color(0xFF6B4F36),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Select photo from your gallery\nor use the camera',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF6B4F36),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _UploadButton(
                      iconPath: 'assets/icons/camera.png',
                      label: 'Camera',
                      onTap: () => _handleUpload(context, fromCamera: true),
                    ),
                    _UploadButton(
                      iconPath: 'assets/icons/gallery-outlined-icon.png',
                      label: 'Gallery',
                      onTap: () => _handleUpload(context, fromCamera: false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigation(
            items: [
              BottomNavItem(iconPath: 'assets/icons/home-outlined-icon.png', label: 'Home'),
              BottomNavItem(iconPath: 'assets/icons/gallery-outlined-icon.png', label: 'Gallery'),
              BottomNavItem(iconPath: 'assets/icons/camera.png', label: ''),
              BottomNavItem(
                iconPath: 'assets/icons/favourites-outlined-icon.png',
                label: 'Favourites',
              ),
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
        ),
        if (_loading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _UploadButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const _UploadButton({required this.iconPath, required this.label, required this.onTap, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 36, height: 36, color: const Color(0xFF6B4F36)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B4F36),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
