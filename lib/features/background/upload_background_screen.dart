import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/features/pose/presentation/pages/view_pose_screen.dart';
import 'package:posea_mobile_app/features/poses/data/datasources/pose_image_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/repositories/pose_image_repository.dart';
import 'package:provider/provider.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';

class UploadBackgroundScreen extends StatefulWidget {
  const UploadBackgroundScreen({Key? key}) : super(key: key);

  @override
  State<UploadBackgroundScreen> createState() => _UploadBackgroundScreenState();
}

class _UploadBackgroundScreenState extends State<UploadBackgroundScreen> {
  bool _loading = false;
  String _selectedGender = 'all';

  Future<bool> _showUploadAnywayDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final shouldUploadAnyway = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.beachImageWarningTitle),
          content: Text(l10n.beachImageWarningMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.uploadAnyway),
            ),
          ],
        );
      },
    );

    return shouldUploadAnyway ?? false;
  }

  Future<bool> _isLikelyBeachImage(Uint8List bytes) async {
    try {
      final image = await _decodeImage(bytes);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) {
        return true;
      }

      final pixels = byteData.buffer.asUint8List();
      final width = image.width;
      final height = image.height;

      final stepX = max(1, width ~/ 32);
      final stepY = max(1, height ~/ 32);

      int sampled = 0;
      int topSamples = 0;
      int bottomSamples = 0;
      int topSkyCount = 0;
      int warmSkyCount = 0;
      int bottomBeachCount = 0;
      int greenCount = 0;
      int blueOverallCount = 0;
      int sandOverallCount = 0;

      final splitTop = (height * 0.55).toInt();
      final splitBottom = (height * 0.35).toInt();

      for (int y = 0; y < height; y += stepY) {
        for (int x = 0; x < width; x += stepX) {
          final index = (y * width + x) * 4;
          final r = pixels[index];
          final g = pixels[index + 1];
          final b = pixels[index + 2];

          final hsv = HSVColor.fromColor(Color.fromARGB(255, r, g, b));
          final hue = hsv.hue;
          final sat = hsv.saturation;
          final val = hsv.value;

          final isBlue = hue >= 175 && hue <= 250 && sat > 0.12 && val > 0.20;
          final isWarmSky = hue >= 10 && hue <= 60 && sat >= 0.08 && sat <= 0.75 && val > 0.30;
          final isSand = hue >= 18 && hue <= 58 && sat >= 0.08 && sat <= 0.80 && val > 0.30;
          final isWater = hue >= 160 && hue <= 235 && sat > 0.15 && val > 0.18;
          final isGreen = hue >= 70 && hue <= 160 && sat > 0.2 && val > 0.2;

          sampled++;
          if (isBlue) {
            blueOverallCount++;
          }
          if (isSand) {
            sandOverallCount++;
          }

          if (y < splitTop) {
            topSamples++;
            if (isBlue || isWarmSky) {
              topSkyCount++;
            }
            if (isWarmSky) {
              warmSkyCount++;
            }
          }

          if (y >= splitBottom) {
            bottomSamples++;
            if (isSand || isWater) {
              bottomBeachCount++;
            }
          }

          if (isGreen) {
            greenCount++;
          }
        }
      }

      if (sampled == 0) {
        return true;
      }

      final topSkyRatio = topSamples == 0 ? 0.0 : topSkyCount / topSamples;
      final warmSkyRatio = topSamples == 0 ? 0.0 : warmSkyCount / topSamples;
      final bottomBeachRatio = bottomSamples == 0 ? 0.0 : bottomBeachCount / bottomSamples;
      final greenRatio = greenCount / sampled;
      final blueOverallRatio = blueOverallCount / sampled;
      final sandOverallRatio = sandOverallCount / sampled;

      final classicBeach = topSkyRatio > 0.20 && bottomBeachRatio > 0.30 && greenRatio < 0.75;
      final waterDominantBeach =
          blueOverallRatio > 0.26 && bottomBeachRatio > 0.22 && greenRatio < 0.78;
      final sunsetBeach = warmSkyRatio > 0.10 && sandOverallRatio > 0.10 && greenRatio < 0.78;

      return classicBeach || waterDominantBeach || sunsetBeach;
    } catch (_) {
      return true;
    }
  }

  Future<ui.Image> _decodeImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }

  Future<void> _handleUpload(BuildContext context, {required bool fromCamera}) async {
    final l10n = AppLocalizations.of(context)!;
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
        await AppFeedback.showErrorSheet(l10n.noImageSelected);
        return;
      }
      final bytes = await File(pickedFile.path).readAsBytes();

      final isBeach = await _isLikelyBeachImage(bytes);
      if (!isBeach) {
        if (!mounted) return;
        final shouldUploadAnyway = await _showUploadAnywayDialog();
        if (!shouldUploadAnyway) {
          await AppFeedback.showErrorSheet(AppLocalizations.of(context)!.beachImageRequired);
          return;
        }
      }

      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      // Get access token from AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final accessToken = authProvider.token;
      if (accessToken == null) {
        await AppFeedback.showErrorSheet(l10n.userNotAuthenticated);
        return;
      }

      final poseRepo = PoseImageRepository(apiService: PoseImageApiService());
      final requestedGender = _selectedGender == 'all' ? null : _selectedGender;
      final poses = await poseRepo.suggestPoses(
        imageBase64: base64Image,
        accessToken: accessToken,
        gender: requestedGender,
      );

      final filteredPoses = poses == null || requestedGender == null
          ? poses
          : poses
                .where((pose) => pose.gender.toLowerCase() == requestedGender.toLowerCase())
                .toList();
      if (filteredPoses != null) {
        if (!mounted) return;
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ViewPoseScreen(poses: filteredPoses)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF8F7F5),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              l10n.uploadBackgroundTitle,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
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
                      children: [
                        const Icon(Icons.add_a_photo, size: 48, color: Color(0xFF6B4F36)),
                        const SizedBox(height: 12),
                        Text(
                          l10n.uploadBackgroundCardTitle,
                          style: const TextStyle(
                            color: Color(0xFF6B4F36),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.uploadBackgroundCardSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _GenderFilterChip(
                      label: 'All',
                      selected: _selectedGender == 'all',
                      onSelected: () => setState(() => _selectedGender = 'all'),
                    ),
                    _GenderFilterChip(
                      label: 'Male',
                      selected: _selectedGender == 'male',
                      onSelected: () => setState(() => _selectedGender = 'male'),
                    ),
                    _GenderFilterChip(
                      label: 'Female',
                      selected: _selectedGender == 'female',
                      onSelected: () => setState(() => _selectedGender = 'female'),
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

class _GenderFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _GenderFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFF6B4F36),
      labelStyle: TextStyle(color: selected ? Colors.white : const Color(0xFF6B4F36)),
      side: const BorderSide(color: Color(0xFF6B4F36)),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      showCheckmark: false,
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
