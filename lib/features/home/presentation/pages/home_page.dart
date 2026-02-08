import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posea_mobile_app/features/home/application/pose_of_the_day_provider.dart';
import 'package:posea_mobile_app/features/poses/data/datasources/pose_image_api_service.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/core/widgets/search_input_field.dart';
import 'package:posea_mobile_app/features/home/presentation/widgets/greeting_search_widgets.dart';

import 'package:posea_mobile_app/features/home/presentation/widgets/pose_of_the_day_card.dart';
import 'package:posea_mobile_app/features/home/presentation/widgets/quick_link_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PoseOfTheDayProvider>(
          create: (context) => PoseOfTheDayProvider(
            apiService: PoseImageApiService(),
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          )..fetchPoseOfTheDay(),
        ),
      ],
      child: Scaffold(
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
                            context.go(RouteNames.malePoses);
                          },
                        ),
                      ),
                      Expanded(
                        child: QuickLinkCard(
                          title: 'Female Poses',
                          image: 'assets/images/female-pose-sample.png',
                          onTap: () {
                            context.go(RouteNames.femalePoses);
                          },
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 24),
                  // const Text(
                  //   'Browse by style',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 12),
                  // const BrowseByStyleGrid(),
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
            BottomNavItem(
              iconPath: 'assets/icons/favourites-outlined-icon.png',
              label: 'Favourites',
            ),
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
      ),
    );
  }
}
