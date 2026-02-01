import 'package:flutter/material.dart';
import 'package:posea_mobile_app/core/widgets/common_bottom_sheets_demo.dart';
import '../../../../core/widgets/index.dart';
import 'package:posea_mobile_app/core/widgets/settings_options_card.dart';

class WidgetsShowcasePage extends StatefulWidget {
  const WidgetsShowcasePage({super.key});

  @override
  State<WidgetsShowcasePage> createState() => _WidgetsShowcasePageState();
}

class _WidgetsShowcasePageState extends State<WidgetsShowcasePage> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets Showcase'),
        backgroundColor: const Color(0xFF8B6F47),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Asset
            _buildSectionTitle('Logo Asset'),
            const SizedBox(height: 12),
            const LogoAsset(assetPath: 'assets/images/app_logo.svg', width: 120),
            const SizedBox(height: 32),

            // Custom Buttons
            _buildSectionTitle('Custom Buttons'),
            const SizedBox(height: 12),
            CustomButton(onPressed: () {}, label: 'Sign In'),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () {},
              label: 'Continue as guest',
              isBordered: true,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
            ),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () {},
              label: 'Retake',
              isBordered: true,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              width: 120,
              height: 45,
            ),
            const SizedBox(height: 32),

            // Custom Text Input Field
            _buildSectionTitle('Custom Text Input Field'),
            const SizedBox(height: 12),
            CustomTextInputField(
              hintText: 'Enter your Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomTextInputField(
              hintText: 'Enter your Password',
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            const SizedBox(height: 32),

            // Search Input Field
            _buildSectionTitle('Search Input Field'),
            const SizedBox(height: 12),
            SearchInputField(hintText: 'Find your pose ...'),
            const SizedBox(height: 32),

            // Social Login Buttons
            _buildSectionTitle('Social Login Buttons'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SocialLoginButton(
                    label: 'Google',
                    onPressed: () {},
                    backgroundColor: const Color(0xFF8B6F47),
                    iconPath: 'assets/icons/google-coloured-icon.png',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SocialLoginButton(
                    label: 'Facebook',
                    onPressed: () {},
                    backgroundColor: const Color(0xFF8B6F47),
                    iconPath: 'assets/icons/Facebook-coloured-icon.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Custom Card
            _buildSectionTitle('Custom Card'),
            const SizedBox(height: 12),
            CustomCard(
              title: 'Find pose for your scenery',
              subtitle: 'Upload the background image',
              iconPath: 'assets/icons/camera.png',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Custom Bottom Sheets
            _buildSectionTitle('Custom Bottom Sheets'),
            const SizedBox(height: 12),
            CommonBottomSheetsDemo(),
            const SizedBox(height: 32),

            // Settings Options Card
            _buildSectionTitle('Settings Options Card'),
            const SizedBox(height: 12),
            SettingsOptionsCard(
              options: [
                SettingsOption(
                  icon: Icons.lock_outline,
                  label: 'Change password',
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Change password tapped'))),
                ),
                SettingsOption(
                  icon: Icons.language,
                  label: 'Language',
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Language tapped'))),
                ),
                SettingsOption(
                  icon: Icons.delete_outline,
                  label: 'Delete Account',
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Delete Account tapped'))),
                ),
                SettingsOption(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Privacy Policy tapped'))),
                ),
                SettingsOption(
                  icon: Icons.logout,
                  label: 'Log Out',
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Log Out tapped'))),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Bottom Navigation
            _buildSectionTitle('Bottom Navigation'),
            const SizedBox(height: 12),
            const Text(
              'Scroll down to see the bottom navigation in action',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),
          ],
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
        currentIndex: _selectedNavIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on index $index'), duration: const Duration(seconds: 1)),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B6F47)),
    );
  }
}
