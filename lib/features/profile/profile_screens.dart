import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/localization/language_provider.dart';
import 'package:posea_mobile_app/core/widgets/custom_bottom_navigation.dart';
import 'package:posea_mobile_app/core/widgets/custom_button.dart';
import 'package:posea_mobile_app/core/widgets/custom_text_input_field.dart';
import 'package:posea_mobile_app/core/widgets/settings_options_card.dart';
import 'package:posea_mobile_app/core/widgets/common_bottom_sheets.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:provider/provider.dart';

void showProfileImagePreviewDialog(BuildContext context, ImageProvider imageProvider) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image(image: imageProvider, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

ImageProvider? profileImageProviderFromBase64(String userImage) {
  final img = userImage.trim();
  if (img.isEmpty) {
    return null;
  }
  try {
    if (img.startsWith('data:image')) {
      final base64Str = img
          .substring(img.indexOf(',') + 1)
          .replaceAll('\n', '')
          .replaceAll(' ', '');
      return MemoryImage(base64Decode(base64Str));
    }
    return MemoryImage(base64Decode(img.replaceAll('\n', '').replaceAll(' ', '')));
  } catch (e) {
    print('Failed to decode base64 profile image: $e');
    return null;
  }
}

String usernameFirstLetter(String userName) {
  final trimmed = userName.trim();
  if (trimmed.isEmpty) return 'U';
  return trimmed.substring(0, 1).toUpperCase();
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _showNoImageErrorSheet() async {
    await AppFeedback.showErrorSheet(AppLocalizations.of(context)!.noProfileImageToShow);
  }

  Future<void> _showLanguageSelectionSheet() async {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final selectedCode = languageProvider.locale.languageCode;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                l10n.selectLanguage,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 8),
              ...LanguageProvider.supportedLanguages.map(
                (language) => ListTile(
                  title: Text(language.name),
                  trailing: selectedCode == language.code
                      ? const Icon(Icons.check, color: Color(0xFF8B6F47))
                      : null,
                  onTap: () async {
                    await languageProvider.setLanguage(language.code);
                    if (!mounted) return;
                    Navigator.of(sheetContext).pop();
                    await AppFeedback.showSuccessSheet(
                      l10n.languageUpdated,
                      l10n.languageChangedTo(language.name),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

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
    final l10n = AppLocalizations.of(context)!;
    void goToEditProfile() {
      context.go(RouteNames.editProfile);
    }

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final avatarImage = profileImageProviderFromBase64(auth.userImage);
        return Scaffold(
          backgroundColor: const Color(0xFFF7F5F2),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => context.go(RouteNames.home),
            ),
            title: Text(l10n.profile, style: const TextStyle(color: Colors.black)),
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
                      onTap: () {
                        if (avatarImage != null) {
                          showProfileImagePreviewDialog(context, avatarImage);
                        } else {
                          _showNoImageErrorSheet();
                        }
                      },
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: avatarImage,
                        child: avatarImage == null
                            ? Text(
                                usernameFirstLetter(auth.userName),
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                              )
                            : null,
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
              Text(
                auth.userName.isNotEmpty ? auth.userName : l10n.noName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF8B6F47),
                ),
              ),
              Text(
                auth.userEmail.isNotEmpty ? auth.userEmail : l10n.noEmail,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    l10n.settings,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                      label: l10n.changePassword,
                      onTap: () {
                        context.go(RouteNames.changePassword);
                      },
                    ),
                    SettingsOption(
                      icon: Icons.language,
                      label: l10n.language,
                      onTap: _showLanguageSelectionSheet,
                    ),
                    SettingsOption(
                      icon: Icons.delete_outline,
                      label: l10n.deleteAccount,
                      onTap: () async {
                        if (!context.mounted) return;
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          isScrollControlled: true,
                          builder: (_) => buildDeleteAccountSheet(
                            onDelete: () async {
                              Navigator.of(context).pop();
                              final success = await auth.deleteAccount();
                              if (success) {
                                await AppFeedback.showSuccessSheet(
                                  l10n.accountDeleted,
                                  l10n.accountDeletedDescription,
                                  actionText: l10n.signIn,
                                  onAction: () => context.go(RouteNames.login),
                                );
                              } else if (auth.error != null) {
                                AppFeedback.showErrorSheet(auth.error!);
                              }
                            },
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                        );
                      },
                    ),
                    SettingsOption(
                      icon: Icons.privacy_tip_outlined,
                      label: l10n.privacyPolicy,
                      onTap: () {},
                    ),
                    SettingsOption(
                      icon: Icons.logout,
                      label: l10n.logOut,
                      onTap: () async {
                        if (!context.mounted) return;
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          isScrollControlled: true,
                          builder: (_) => buildLogoutSheet(
                            onLogout: () async {
                              Navigator.of(context).pop();
                              await auth.logout();
                              if (!context.mounted) return;
                              context.go(RouteNames.login);
                            },
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigation(
            items: [
              BottomNavItem(iconPath: 'assets/icons/home-outlined-icon.png', label: l10n.home),
              BottomNavItem(
                iconPath: 'assets/icons/gallery-outlined-icon.png',
                label: l10n.gallery,
              ),
              BottomNavItem(iconPath: 'assets/icons/camera.png', label: l10n.camera),
              BottomNavItem(
                iconPath: 'assets/icons/favourites-outlined-icon.png',
                label: l10n.favourites,
              ),
              BottomNavItem(
                iconPath: 'assets/icons/profile-outlined-icon.png',
                label: l10n.profile,
              ),
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
  bool removeProfileImage = false;
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

  Future<void> _pickImage(ImageSource source) async {
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        pickedImage = image;
        removeProfileImage = false;
      });
    }
  }

  Future<void> _showImageOptionsSheet() async {
    final l10n = AppLocalizations.of(context)!;
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(l10n.camera),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l10n.gallery),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.removeProfileImage),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  final shouldRemove = await _confirmRemoveProfileImage();
                  if (shouldRemove == true && mounted) {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    final success = await auth.removeProfileImage();
                    if (!mounted) return;
                    if (success) {
                      setState(() {
                        pickedImage = null;
                        removeProfileImage = false;
                      });
                      await AppFeedback.showSuccessSheet(
                        l10n.removed,
                        l10n.profileImageRemovedSuccessfully,
                      );
                    } else if (auth.error != null) {
                      await AppFeedback.showErrorSheet(auth.error!);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _confirmRemoveProfileImage() {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.removeProfileImageQuestion),
          content: Text(l10n.removeProfileImageAfterSave),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.remove),
            ),
          ],
        );
      },
    );
  }

  bool _hasProfileImage(AuthProvider auth) {
    if (pickedImage != null) return true;
    if (removeProfileImage) return false;
    return profileImageProviderFromBase64(auth.userImage) != null;
  }

  Future<void> _showNoImageErrorSheet() async {
    await AppFeedback.showErrorSheet(AppLocalizations.of(context)!.noProfileImageToShow);
  }

  ImageProvider? _currentProfileImageProvider(AuthProvider auth) {
    if (pickedImage != null) {
      return FileImage(File(pickedImage!.path));
    }
    if (removeProfileImage) {
      return null;
    }

    return profileImageProviderFromBase64(auth.userImage);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthProvider>(context);
    final currentProfileImage = _currentProfileImageProvider(auth);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.go(RouteNames.profile),
        ),
        title: Text(l10n.editProfile, style: const TextStyle(color: Colors.black)),
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
                    GestureDetector(
                      onTap: () {
                        if (_hasProfileImage(auth)) {
                          showProfileImagePreviewDialog(context, currentProfileImage!);
                        } else {
                          _showNoImageErrorSheet();
                        }
                      },
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: currentProfileImage,
                        child: currentProfileImage == null
                            ? Text(
                                usernameFirstLetter(auth.userName),
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _showImageOptionsSheet,
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
                auth.userName.isNotEmpty ? auth.userName : l10n.noName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF8B6F47),
                ),
              ),
              Text(
                auth.userEmail.isNotEmpty ? auth.userEmail : l10n.noEmail,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              CustomTextInputField(hintText: l10n.enterYourFullName, controller: nameController),
              const SizedBox(height: 12),
              CustomTextInputField(
                hintText: l10n.enterYourEmail,
                controller: emailController,
                enabled: false,
              ),
              const SizedBox(height: 12),

              CustomTextInputField(
                hintText: l10n.writeSomething,
                controller: bioController,
                maxLines: 3,
                minLines: 3,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: auth.loading
                      ? null
                      : () async {
                          if (bioController.text.trim().isEmpty) {
                            await AppFeedback.showErrorSheet(l10n.bioAlreadyEmpty);
                            return;
                          }
                          final success = await auth.clearBio();
                          if (!context.mounted) return;
                          if (success) {
                            bioController.clear();
                            setState(() {});
                            await AppFeedback.showSuccessSheet(
                              l10n.cleared,
                              l10n.bioClearedSuccessfully,
                            );
                          } else if (auth.error != null) {
                            await AppFeedback.showErrorSheet(auth.error!);
                          }
                        },
                  icon: const Icon(Icons.clear, size: 16),
                  label: Text(l10n.clearBio),
                ),
              ),

              const SizedBox(height: 24),
              CustomButton(
                label: auth.loading ? l10n.saving : l10n.saveChanges,
                onPressed: auth.loading
                    ? null
                    : () async {
                        String? imageBase64;
                        if (removeProfileImage) {
                          imageBase64 = '';
                        } else if (pickedImage != null) {
                          final bytes = await File(pickedImage!.path).readAsBytes();
                          imageBase64 = base64Encode(bytes);
                        }
                        final success = await auth.updateProfile(
                          nameController.text.trim(),
                          bio: bioController.text.trim(),
                          profileImageBase64: imageBase64,
                        );
                        if (success) {
                          await AppFeedback.showSuccessSheet(
                            l10n.updated,
                            l10n.profileUpdatedSuccessfully,
                          );
                          context.go(RouteNames.profile);
                        } else if (auth.error != null) {
                          await AppFeedback.showErrorSheet(auth.error!);
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
          BottomNavItem(iconPath: 'assets/icons/home-outlined-icon.png', label: l10n.home),
          BottomNavItem(iconPath: 'assets/icons/gallery-outlined-icon.png', label: l10n.gallery),
          BottomNavItem(iconPath: 'assets/icons/camera.png', label: l10n.camera),
          BottomNavItem(
            iconPath: 'assets/icons/favourites-outlined-icon.png',
            label: l10n.favorites,
          ),
          BottomNavItem(iconPath: 'assets/icons/profile-outlined-icon.png', label: l10n.profile),
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
