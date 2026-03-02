import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/core/widgets/custom_card.dart';

import 'package:posea_mobile_app/features/poses/data/datasources/pose_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/repositories/pose_repository.dart';
import 'package:posea_mobile_app/features/poses/data/models/pose_model.dart';
import 'package:posea_mobile_app/features/poses/data/datasources/pose_image_api_service.dart';
import 'package:posea_mobile_app/features/poses/data/repositories/pose_image_repository.dart';
import 'dart:convert';

class FemalePosesPage extends StatefulWidget {
  const FemalePosesPage({Key? key}) : super(key: key);

  @override
  State<FemalePosesPage> createState() => _FemalePosesPageState();
}

class _FemalePosesPageState extends State<FemalePosesPage> {
  late final PoseImageRepository _poseImageRepository;
  late final PoseRepository _poseRepository;
  final List<Pose> _poses = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _poseRepository = PoseRepository(apiService: PoseApiService());
    _poseImageRepository = PoseImageRepository(apiService: PoseImageApiService());
    _fetchMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchMore();
    }
  }

  Future<void> _fetchMore() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newPoses = await _poseRepository.getPosesByGender(
        'female',
        limit: _limit,
        offset: _offset,
      );
      setState(() {
        _poses.addAll(newPoses);
        _offset += newPoses.length;
        _hasMore = newPoses.length == _limit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Female Poses',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomCard(
              iconPath: 'assets/icons/camera.png',
              title: 'Find pose for your scenery',
              subtitle: 'Upload the background image',
              backgroundColor: const Color.fromARGB(121, 136, 97, 62),
              iconBackgroundColor: const Color.fromARGB(255, 75, 46, 10),
              onTap: () {
                context.go(RouteNames.uploadBackground);
              },
            ),
          ),
          Expanded(
            child: _poses.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _poses.isEmpty
                ? const Center(child: Text('No poses found.'))
                : NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!_isLoading &&
                          _hasMore &&
                          scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                        _fetchMore();
                      }
                      return false;
                    },
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      padding: const EdgeInsets.all(16),
                      itemCount: _poses.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _poses.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final pose = _poses[index];
                        Widget imageWidget;
                        if (pose.poseImageBase64 != null &&
                            pose.poseImageBase64!.startsWith('data:image')) {
                          final base64Str = pose.poseImageBase64!.split(',').last;
                          imageWidget = Image.memory(base64Decode(base64Str), fit: BoxFit.cover);
                        } else {
                          final imageUrl = 'http://10.239.85.112:8000/static/${pose.poseImage}';
                          imageWidget = Image.network(imageUrl, fit: BoxFit.cover);
                        }
                        String? base64Image;
                        if (pose.poseImageBase64 != null &&
                            pose.poseImageBase64!.startsWith('data:image')) {
                          final base64Str = pose.poseImageBase64!.split(',').last;
                          base64Image = base64Str;
                          imageWidget = Image.memory(base64Decode(base64Str), fit: BoxFit.cover);
                        }
                        return GestureDetector(
                          onTap: () async {
                            String? fetchedBase64;
                            if (pose.poseImage.isNotEmpty) {
                              fetchedBase64 = await _poseImageRepository.getPoseImageBase64(
                                pose.poseId,
                              );
                            }
                            context.push(
                              '/preview-pose',
                              extra: {
                                'base64Image': fetchedBase64,
                                'gender': 'female',
                                'pose_id': pose.poseId.toString(),
                                'description': pose.description,
                                'scene_tag': pose.sceneTag,
                                'lighting_tag': pose.lightingTag,
                                'skeletonData': pose.skeletonData,
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imageWidget,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        items: [
          BottomNavItem(iconPath: 'assets/icons/home-outlined-icon.png', label: 'Home'),
          BottomNavItem(iconPath: 'assets/icons/gallery-outlined-icon.png', label: 'Gallery'),
          BottomNavItem(iconPath: 'assets/icons/camera.png', label: 'Camera'),
          BottomNavItem(iconPath: 'assets/icons/favourites-outlined-icon.png', label: 'Favourites'),
          BottomNavItem(iconPath: 'assets/icons/profile-outlined-icon.png', label: 'Profile'),
        ],
        currentIndex: 0,
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
