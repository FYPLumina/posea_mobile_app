import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/core/widgets/custom_button.dart';
import 'package:posea_mobile_app/core/widgets/custom_text_input_field.dart';
import 'package:posea_mobile_app/core/widgets/settings_options_card.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when navigating to this screen
    Future.microtask(() {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    void goToEditProfile() {
      context.go(RouteNames.editProfile);
    }

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        ImageProvider avatarImage;
        if (auth.userImage.isNotEmpty) {
          final img = auth.userImage.trim();
          try {
            if (img.startsWith('data:image')) {
              final base64Str = img
                  .substring(img.indexOf(',') + 1)
                  .replaceAll('\n', '')
                  .replaceAll(' ', '');
              avatarImage = MemoryImage(base64Decode(base64Str));
            } else {
              avatarImage = MemoryImage(base64Decode(img.replaceAll('\n', '').replaceAll(' ', '')));
            }
          } catch (e) {
            print('Failed to decode base64 profile image: $e');
            avatarImage = const AssetImage('assets/images/profile.jpg');
          }
        } else {
          avatarImage = const AssetImage('assets/images/profile.jpg');
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
                      child: CircleAvatar(radius: 48, backgroundImage: avatarImage),
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
              Text(
                auth.userName.isNotEmpty ? auth.userName : 'No Name',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF8B6F47),
                ),
              ),
              Text(
                auth.userEmail.isNotEmpty ? auth.userEmail : 'No Email',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              if (auth.userBio.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    auth.userBio,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
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
                    SettingsOption(
                      icon: Icons.delete_outline,
                      label: 'Delete Account',
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Delete Account'),
                            content: Text('Are you sure you want to delete your account?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final success = await auth.deleteAccount();
                          if (success) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('Account deleted successfully')));
                            context.go(RouteNames.login);
                          } else if (auth.error != null) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(auth.error!)));
                          }
                        }
                      },
                    ),
                    SettingsOption(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () {},
                    ),
                    SettingsOption(
                      icon: Icons.logout,
                      label: 'Log Out',
                      onTap: () async {
                        await auth.logout();
                        context.go(RouteNames.login);
                      },
                    ),
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
              BottomNavItem(
                iconPath: 'assets/icons/favourites-outlined-icon.png',
                label: 'Favourites',
              ),
              BottomNavItem(iconPath: 'assets/icons/profile-outlined-icon.png', label: 'Profile'),
            ],
            currentIndex: 4,
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
      },
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    nameController = TextEditingController(text: auth.userName);
    emailController = TextEditingController(text: auth.userEmail);
    bioController = TextEditingController(text: auth.userBio);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
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
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: pickedImage != null
                          ? FileImage(File(pickedImage!.path))
                          : (() {
                                  final img = auth.userImage.trim();
                                  if (img.isEmpty)
                                    return const AssetImage('assets/images/profile.jpg');
                                  try {
                                    if (img.startsWith('data:image')) {
                                      final base64Str = img
                                          .substring(img.indexOf(',') + 1)
                                          .replaceAll('\n', '')
                                          .replaceAll(' ', '');
                                      return MemoryImage(base64Decode(base64Str));
                                    } else {
                                      return MemoryImage(
                                        base64Decode(img.replaceAll('\n', '').replaceAll(' ', '')),
                                      );
                                    }
                                  } catch (e) {
                                    print('Failed to decode base64 profile image: $e');
                                    return const AssetImage('assets/images/profile.jpg');
                                  }
                                })()
                                as ImageProvider,
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
              Text(
                auth.userName.isNotEmpty ? auth.userName : 'No Name',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF8B6F47),
                ),
              ),
              Text(
                auth.userEmail.isNotEmpty ? auth.userEmail : 'No Email',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              CustomTextInputField(hintText: 'Enter your Full Name', controller: nameController),
              const SizedBox(height: 12),
              CustomTextInputField(
                hintText: 'Enter your Email',
                controller: emailController,
                enabled: false,
              ),
              const SizedBox(height: 12),
              CustomTextInputField(
                hintText: 'Write Something..........',
                controller: bioController,
                maxLines: 3,
                minLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    onPressed: () async {
                      final image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          pickedImage = image;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    onPressed: () async {
                      final image = await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          pickedImage = image;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(auth.error!, style: const TextStyle(color: Colors.red)),
                ),
              CustomButton(
                label: auth.loading ? 'Saving...' : 'Save Changes',
                onPressed: auth.loading
                    ? null
                    : () async {
                        String? imageBase64;
                        if (pickedImage != null) {
                          final bytes = await File(pickedImage!.path).readAsBytes();
                          imageBase64 = base64Encode(bytes);
                        }
                        final success = await auth.updateProfile(
                          nameController.text.trim(),
                          bio: bioController.text.trim(),
                          profileImageBase64: imageBase64,
                        );
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated successfully')),
                          );
                          context.go(RouteNames.profile);
                        } else if (auth.error != null) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(auth.error!)));
                        }
                      },
                backgroundColor: const Color(0xFF8B6F47),
                textColor: Colors.white,
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
