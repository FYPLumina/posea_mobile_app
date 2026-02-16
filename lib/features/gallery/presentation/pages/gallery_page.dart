import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:posea_mobile_app/core/config/app_config.dart';
import 'package:posea_mobile_app/core/network/auth_service.dart';
import 'package:posea_mobile_app/features/gallery/data/datasources/gallery_api_service.dart';
import 'package:posea_mobile_app/features/gallery/data/models/captured_image.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/core/theme/app_colors.dart';
import 'package:posea_mobile_app/core/theme/app_text_styles.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late Future<List<CapturedImage>> _imagesFuture;
  List<CapturedImage> _images = [];
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    print('GalleryPage initState called');
    _imagesFuture = _fetchImages();
  }

  Future<List<CapturedImage>> _fetchImages() async {
    print('_fetchImages called');
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      _accessToken = token;
      print('Token: ' + (token ?? 'NULL'));
      if (token == null) return [];
      print('AppConfig.baseUrl: ' + AppConfig.baseUrl);
      final api = GalleryApiService(AppConfig.baseUrl.replaceAll('/api', ''));
      print('GalleryApiService created with baseUrl: ' + AppConfig.baseUrl.replaceAll('/api', ''));
      final data = await api.fetchCapturedImages(token);
      print('Data fetched: ${data.length} items');
      final result = <CapturedImage>[];
      for (var i = 0; i < data.length; i++) {
        try {
          result.add(CapturedImage.fromJson(data[i]));
        } catch (e) {
          print('Error parsing CapturedImage at index $i: $e');
        }
      }
      _images = result;
      return result;
    } catch (e, st) {
      print('Error in _fetchImages: $e\n$st');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print('GalleryPage build called');
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Gallery', style: AppTextStyles.titleLarge),
        ),
      ),
      body: FutureBuilder<List<CapturedImage>>(
        future: _imagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No images found'));
          }
          final images = _images;
          print('Building GridView with images.length = \\${images.length}');
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              print('itemBuilder called for index \\${index}');
              final img = images[index];
              // Always remove the data URL prefix if present
              String base64StrRaw = img.capturedImageBase64.trim();
              print(
                'Image \\${index} base64 (first 100, raw): ' +
                    base64StrRaw.substring(
                      0,
                      base64StrRaw.length > 100 ? 100 : base64StrRaw.length,
                    ),
              );
              // Remove everything up to and including 'base64,'
              String base64Str = base64StrRaw.replaceFirst(
                RegExp(r'^.*base64,', caseSensitive: false),
                '',
              );
              print(
                'Image \\${index} base64 (first 100, cleaned): ' +
                    base64Str.substring(0, base64Str.length > 100 ? 100 : base64Str.length),
              );
              Widget imageWidget;
              try {
                final bytes = base64Decode(base64Str);
                print('Image \\${index} bytes length: ' + bytes.length.toString());
                imageWidget = Image.memory(
                  bytes,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.orange[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 40, color: Colors.red),
                    ),
                  ),
                );
              } catch (e) {
                print('Image \\${index} decode error: \\${e}');
                imageWidget = Container(
                  color: Colors.red[100],
                  child: const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.red)),
                );
              }
              return Stack(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(16), child: imageWidget),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          img.isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.primary,
                        ),
                        onPressed: () async {
                          if (_accessToken == null) return;
                          final api = GalleryApiService(AppConfig.baseUrl.replaceAll('/api', ''));
                          final newFav = await api.setFavourite(
                            accessToken: _accessToken!,
                            capImageId: img.capImageId,
                            isFavourite: !img.isFavourite,
                          );
                          if (newFav != null) {
                            setState(() {
                              images[index] = CapturedImage(
                                capImageId: img.capImageId,
                                capturedImageBase64: img.capturedImageBase64,
                                userId: img.userId,
                                isFavourite: newFav,
                                capturedTime: img.capturedTime,
                                poseId: img.poseId,
                              );
                            });
                          }
                        },
                        iconSize: 24,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share, color: AppColors.primary),
                        onPressed: () async {
                          try {
                            // Share image as file
                            final bytes = base64Decode(base64Str);
                            final tempDir = await (await getTemporaryDirectory()).path;
                            final filePath = '$tempDir/image_${img.capImageId}.png';
                            final file = await File(filePath).writeAsBytes(bytes);
                            await Share.shareXFiles([
                              XFile(file.path),
                            ], text: 'Check out this image!');
                          } catch (e) {
                            print('Share error: $e');
                            await AppFeedback.showErrorSheet('Failed to share image.');
                          }
                        },
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.download_rounded, color: AppColors.primary),
                        onPressed: () async {
                          try {
                            final bytes = base64Decode(base64Str);
                            final result = await ImageGallerySaverPlus.saveImage(
                              Uint8List.fromList(bytes),
                              quality: 100,
                              name: 'posea_image_${img.capImageId}',
                            );
                            if (result['isSuccess'] == true || result['isSuccess'] == 1) {
                              await AppFeedback.showSuccessSheet(
                                'Saved',
                                'Image saved to gallery.',
                              );
                            } else {
                              throw Exception('Save failed');
                            }
                          } catch (e) {
                            print('Save error: $e');
                            await AppFeedback.showErrorSheet('Failed to save image.');
                          }
                        },
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigation(
        items: [
          BottomNavItem(iconPath: 'assets/icons/home-outlined-icon.png', label: 'Home'),
          BottomNavItem(iconPath: 'assets/icons/gallery-outlined-icon.png', label: 'Gallery'),
          BottomNavItem(iconPath: 'assets/icons/camera.png', label: 'Camera'),
          BottomNavItem(iconPath: 'assets/icons/favourites-outlined-icon.png', label: 'Favourites'),
          BottomNavItem(iconPath: 'assets/icons/profile-outlined-icon.png', label: 'Profile'),
        ],
        currentIndex: 1,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.home);
              break;
            case 1:
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
