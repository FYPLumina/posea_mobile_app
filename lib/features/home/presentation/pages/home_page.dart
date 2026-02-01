import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/core/widgets/search_input_field.dart';
import 'package:posea_mobile_app/features/home/presentation/widgets/browse_by_style_grid.dart';
import 'package:posea_mobile_app/features/home/presentation/widgets/greeting_search_widgets.dart';

import 'package:posea_mobile_app/features/home/presentation/widgets/pose_of_the_day_card.dart';
import 'package:posea_mobile_app/features/home/presentation/widgets/quick_link_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const GreetingSection(),
                const SizedBox(height: 12),
                SearchInputField(hintText: 'Find your pose ...'),

                const SizedBox(height: 24),
                const PoseOfTheDayCard(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: QuickLinkCard(
                        title: 'Male Poses',
                        image: 'assets/images/male-pose-sample.png',
                        onTap: () {
                          context.go('/male-poses');
                        },
                      ),
                    ),
                    Expanded(
                      child: QuickLinkCard(
                        title: 'Female Poses',
                        image: 'assets/images/female-pose-sample.png',
                        onTap: () {
                          context.go('/female-poses');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Browse by style',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const BrowseByStyleGrid(),
              ],
            ),
          ),
        ),
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
          // TODO: Implement navigation logic
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on index $index'), duration: const Duration(seconds: 1)),
          );
        },
      ),
    );
  }
}
