import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_input_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final oldPasswordController = TextEditingController();
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F2),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.go(RouteNames.profile),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Create New Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B6F47),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Your new password must be different from\nprevious password',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Old Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextInputField(
                  hintText: 'Enter your Old Password',
                  controller: oldPasswordController,
                  obscureText: true,
                  onChanged: (_) {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    auth.clearError();
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'New Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextInputField(
                  hintText: 'Enter your New Password',
                  controller: newPasswordController,
                  obscureText: true,
                  onChanged: (_) {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    auth.clearError();
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextInputField(
                  hintText: 'Enter again password',
                  controller: confirmPasswordController,
                  obscureText: true,
                  onChanged: (_) {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    auth.clearError();
                  },
                ),
                const SizedBox(height: 48),
                Center(
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return CustomButton(
                        label: auth.loading ? 'Resetting...' : 'Reset Password',
                        onPressed: auth.loading
                            ? null
                            : () async {
                                if (newPasswordController.text != confirmPasswordController.text) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
                                  return;
                                }
                                await auth.changePassword(
                                  oldPasswordController.text,
                                  newPasswordController.text,
                                );
                                if (auth.error == null) {
                                  await AppFeedback.showSuccessSheet(
                                    'Password Changed',
                                    'Your password has been updated successfully',
                                    actionText: 'Done',
                                    onAction: () => context.go(RouteNames.profile),
                                  );
                                }
                              },
                        backgroundColor: const Color(0xFF8B6F47),
                        textColor: Colors.white,
                        width: 220,
                        height: 48,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
