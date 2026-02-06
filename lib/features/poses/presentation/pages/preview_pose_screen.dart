import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';

class PreviewPoseScreen extends StatelessWidget {
  const PreviewPoseScreen({Key? key}) : super(key: key);

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
          'Preview pose',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _PoseImage('https://images.unsplash.com/photo-1506744038136-46273834b3fb'),
                  _PoseImage('https://images.unsplash.com/photo-1465101046530-73398c7f1b58'),
                  _PoseImage('https://images.unsplash.com/photo-1519125323398-675f0ddb6308'),
                  _PoseImage('https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e'),
                  _PoseImage('https://images.unsplash.com/photo-1506784365847-bbad939e5333'),
                  _PoseImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _UploadBackgroundButton(),
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
              // Navigate to Gallery
              break;
            case 2:
              context.go(RouteNames.uploadBackground);
              break;
            case 3:
              // Navigate to Favorites
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

class _PoseImage extends StatelessWidget {
  final String imageUrl;
  const _PoseImage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(imageUrl, fit: BoxFit.cover, height: 180, width: double.infinity),
    );
  }
}

class _UploadBackgroundButton extends StatelessWidget {
  const _UploadBackgroundButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC2B6AA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
        ),
        onPressed: () {
          context.go(RouteNames.uploadBackground);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.camera_alt, color: Color(0xFF6B4F36)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Upload New Background',
                style: TextStyle(
                  color: Color(0xFF6B4F36),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF6B4F36), size: 18),
          ],
        ),
      ),
    );
  }
}
