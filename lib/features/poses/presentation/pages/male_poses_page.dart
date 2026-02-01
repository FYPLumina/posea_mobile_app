import 'package:flutter/material.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/core/widgets/custom_card.dart';
import 'package:go_router/go_router.dart';

class MalePosesPage extends StatelessWidget {
  const MalePosesPage({Key? key}) : super(key: key);

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
          'Male Poses',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
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
              onTap: () {},
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: const EdgeInsets.all(16),
              children: List.generate(
                6,
                (index) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/male_pose_${index + 1}.jpg', fit: BoxFit.cover),
                ),
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
          BottomNavItem(iconPath: 'assets/icons/favourites-outlined-icon.png', label: 'Favorites'),
          BottomNavItem(iconPath: 'assets/icons/profile-outlined-icon.png', label: 'Profile'),
        ],
        currentIndex: 0,
        onItemTapped: (index) {
          if (index == 0) context.go('/home');
        },
      ),
    );
  }
}
