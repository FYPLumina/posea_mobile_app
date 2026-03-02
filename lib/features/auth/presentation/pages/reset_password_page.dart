import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/core/utils/validators.dart';
import 'package:posea_mobile_app/core/widgets/custom_button.dart';
import 'package:posea_mobile_app/core/widgets/custom_text_input_field.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, this.initialToken});

  final String? initialToken;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tokenController;
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.setNewPassword,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B6F47),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.resetTokenAndPasswordDescription,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                CustomTextInputField(
                  hintText: l10n.enterResetToken,
                  controller: _tokenController,
                  validator: (value) => Validators.validateRequired(value, label: l10n.resetToken),
                ),
                const SizedBox(height: 12),
                CustomTextInputField(
                  hintText: l10n.enterNewPassword,
                  controller: _newPasswordController,
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 6),
                Text(l10n.useAtLeast8, style: TextStyle(fontSize: 14, color: Colors.black54)),
                const Spacer(),
                CustomButton(
                  onPressed: auth.loading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() != true) return;

                          final token = _tokenController.text.trim();
                          final newPassword = _newPasswordController.text.trim();
                          final success = await auth.resetPasswordWithToken(token, newPassword);
                          if (!context.mounted) return;

                          if (success) {
                            await AppFeedback.showSuccessSheet(
                              l10n.passwordResetSuccessful,
                              l10n.passwordResetSuccessfulDescription,
                              actionText: l10n.signIn,
                              onAction: () => context.go(RouteNames.login),
                            );
                          } else if (auth.error != null) {
                            await AppFeedback.showErrorSheet(auth.error!);
                          }
                        },
                  label: auth.loading ? l10n.resetting : l10n.resetPassword,
                  backgroundColor: const Color(0xFF9B8572),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
