import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_input_field.dart';
import '../../core/widgets/custom_bottom_navigation.dart';
import '../../core/widgets/settings_options_card.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goToEditProfile() {
      context.go(RouteNames.editProfile);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.go(RouteNames.home),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: goToEditProfile,
                  child: const CircleAvatar(
                    radius: 48,
                    //TODO: Replace with dynamic user image
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: goToEditProfile,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.edit, size: 20, color: Color(0xFF8B6F47)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            //TODO: Replace with dynamic user name
            'Kemmi Miyurasi',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0xFF8B6F47)),
          ),
          const Text(
            //TODO: Replace with dynamic user email
            'kemmimiyurasi@gmail.com',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Settings', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SettingsOptionsCard(
              options: [
                SettingsOption(
                  icon: Icons.lock_outline,
                  label: 'Change password',
                  onTap: () {
                    context.go(RouteNames.changePassword);
                  },
                ),
                SettingsOption(icon: Icons.language, label: 'Language', onTap: () {}),
                SettingsOption(icon: Icons.delete_outline, label: 'Delete Account', onTap: () {}),
                SettingsOption(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () {},
                ),
                SettingsOption(icon: Icons.logout, label: 'Log Out', onTap: () {}),
              ],
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
        currentIndex: 4,
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

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final userNameController = TextEditingController();
    final emailController = TextEditingController();
    final bioController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.go(RouteNames.profile),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      //TODO: Replace with dynamic user image
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.edit, size: 20, color: Color(0xFF8B6F47)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                //TODO: Replace with dynamic user name
                'Kemmi Miyurasi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF8B6F47),
                ),
              ),
              const Text(
                //TODO: Replace with dynamic user email
                'kemmimiyurasi@gmail.com',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              //TODO: Pre-fill the controllers with existing user data
              CustomTextInputField(hintText: 'Enter your Full Name', controller: nameController),
              const SizedBox(height: 12),
              //TODO: Pre-fill the controllers with existing user data
              CustomTextInputField(
                hintText: 'Enter your User Name',
                controller: userNameController,
              ),
              const SizedBox(height: 12),
              //TODO: Pre-fill the controllers with existing user data
              CustomTextInputField(hintText: 'Enter your Email', controller: emailController),
              const SizedBox(height: 12),
              //TODO: Pre-fill the controllers with existing user data
              CustomTextInputField(
                hintText: 'Write Something..........',
                controller: bioController,
                maxLines: 3,
                minLines: 3,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Save Changes',
                onPressed: () {},
                backgroundColor: const Color(0xFF8B6F47),
                textColor: Colors.white,
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Log Out',
                onPressed: () {},
                backgroundColor: Colors.white,
                textColor: const Color(0xFF8B6F47),
                isBordered: true,
                borderColor: const Color(0xFF8B6F47),
              ),
              const SizedBox(height: 24),
            ],
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
        currentIndex: 4,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.home);
              break;
            case 1:
              break;
            case 2:
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
