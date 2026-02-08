import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/config/app_config.dart';
import 'package:posea_mobile_app/core/network/auth_service.dart';
import 'package:posea_mobile_app/core/theme/app_colors.dart';
import 'package:posea_mobile_app/core/theme/app_text_styles.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/features/gallery/data/datasources/gallery_api_service.dart';
import 'package:posea_mobile_app/features/gallery/data/models/captured_image.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  late Future<List<CapturedImage>> _favouritesFuture = Future.value([]);
  @override
  void initState() {
    super.initState();
    _favouritesFuture = _fetchFavourites();
  }

  Future<List<CapturedImage>> _fetchFavourites() async {
    final authService = AuthService();
    final token = await authService.getToken();
    if (token == null) return [];
    final api = GalleryApiService(AppConfig.baseUrl.replaceAll('/api', ''));
    final data = await api.fetchCapturedImages(token);
    final result = <CapturedImage>[];
    for (var i = 0; i < data.length; i++) {
      try {
        final img = CapturedImage.fromJson(data[i]);
        if (img.isFavourite) {
          result.add(img);
        }
      } catch (_) {}
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text('Favourites', style: AppTextStyles.titleLarge),
        ),
      ),
      body: FutureBuilder<List<CapturedImage>>(
        future: _favouritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favourites found'));
          }
          final images = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final img = images[index];
                String base64StrRaw = img.capturedImageBase64.trim();
                String base64Str = base64StrRaw.replaceFirst(
                  RegExp(r'^.*base64,', caseSensitive: false),
                  '',
                );
                Widget imageWidget;
                try {
                  final bytes = base64Decode(base64Str);
                  imageWidget = Image.memory(
                    bytes,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                } catch (_) {
                  imageWidget = Container(
                    color: Colors.red[100],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 40, color: Colors.red),
                    ),
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
                            size: 28,
                          ),
                          onPressed: () async {
                            final authService = AuthService();
                            final token = await authService.getToken();
                            if (token == null) return;
                            final api = GalleryApiService(AppConfig.baseUrl.replaceAll('/api', ''));
                            final newFav = await api.setFavourite(
                              accessToken: token,
                              capImageId: img.capImageId,
                              isFavourite: !img.isFavourite,
                            );
                            if (newFav != null) {
                              setState(() {
                                _favouritesFuture = _fetchFavourites();
                              });
                            }
                          },
                          iconSize: 28,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
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
        currentIndex: 3,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.home);
              break;
            case 1:
              context.go(RouteNames.gallery);
              break;
            case 2:
              context.go(RouteNames.wireframeCamera);
              break;
            case 3:
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

// ...existing code...
