import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/features/poses/data/datasources/pose_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/repositories/pose_repository.dart';
import 'package:posea_mobile_app/features/poses/data/models/pose_model.dart';

class PreviewPoseScreen extends StatefulWidget {
  final String gender;
  const PreviewPoseScreen({Key? key, required this.gender}) : super(key: key);

  @override
  State<PreviewPoseScreen> createState() => _PreviewPoseScreenState();
}

class _PreviewPoseScreenState extends State<PreviewPoseScreen> {
  late final PoseRepository _poseRepository;
  late Future<List<Pose>> _posesFuture;

  @override
  void initState() {
    super.initState();
    // Set your API base URL here
    _poseRepository = PoseRepository(
      apiService: PoseApiService(baseUrl: 'http://10.239.85.112:8000'),
    );
    _posesFuture = _poseRepository.getPosesByGender(widget.gender);
  }

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
              child: FutureBuilder<List<Pose>>(
                future: _posesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No poses found.'));
                  }
                  final poses = snapshot.data!;
                  return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: poses.map((pose) => _PoseImage(pose.poseImage)).toList(),
                  );
                },
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
