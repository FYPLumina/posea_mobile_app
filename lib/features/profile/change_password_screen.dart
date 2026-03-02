import 'package:flutter/material.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/core/utils/validators.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_input_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      l10n.createNewPassword,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B6F47),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      l10n.newPasswordDifferentDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.oldPassword,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextInputField(
                    hintText: l10n.enterYourOldPassword,
                    controller: oldPasswordController,
                    obscureText: true,
                    validator: (value) =>
                        Validators.validateRequired(value, label: l10n.oldPassword),
                    onChanged: (_) {
                      final auth = Provider.of<AuthProvider>(context, listen: false);
                      auth.clearError();
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.newPassword,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextInputField(
                    hintText: l10n.enterYourNewPassword,
                    controller: newPasswordController,
                    obscureText: true,
                    validator: Validators.validatePassword,
                    onChanged: (_) {
                      final auth = Provider.of<AuthProvider>(context, listen: false);
                      auth.clearError();
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.useAtLeast8, style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 20),
                  Text(
                    l10n.confirmPassword,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextInputField(
                    hintText: l10n.enterPasswordAgain,
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      final requiredValidation = Validators.validateRequired(
                        value,
                        label: l10n.confirmPassword,
                      );
                      if (requiredValidation != null) return requiredValidation;
                      if (value != newPasswordController.text) {
                        return l10n.passwordsDoNotMatch;
                      }
                      return null;
                    },
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
                          label: auth.loading ? l10n.resetting : l10n.resetPassword,
                          onPressed: auth.loading
                              ? null
                              : () async {
                                  if (formKey.currentState?.validate() != true) return;
                                  await auth.changePassword(
                                    oldPasswordController.text,
                                    newPasswordController.text,
                                  );
                                  if (auth.error == null) {
                                    await AppFeedback.showSuccessSheet(
                                      l10n.passwordChanged,
                                      l10n.passwordChangedDescription,
                                      actionText: l10n.done,
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
      ),
    );
  }
}
