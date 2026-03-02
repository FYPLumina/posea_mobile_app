import 'package:flutter/material.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/validators.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/index.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateName(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return l10n.nameRequired;
    }
    if (trimmedValue.length < 2) {
      return l10n.nameMin2;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }
    if (value != _passwordController.text) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Example header
                Center(
                  child: Text(
                    l10n.signUpTitle,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 24),
                // Name input
                CustomTextInputField(
                  controller: _nameController,
                  hintText: l10n.enterYourName,
                  lable: l10n.name,
                  onChanged: (_) {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    auth.clearError();
                  },
                  validator: _validateName,
                ),
                SizedBox(height: 12),
                // Email input
                CustomTextInputField(
                  controller: _emailController,
                  hintText: l10n.enterYourEmailLower,
                  lable: l10n.email,
                  onChanged: (_) {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    auth.clearError();
                  },
                  validator: (value) => Validators.validateEmail(value?.trim()),
                ),
                SizedBox(height: 12),
                // Password input
                CustomTextInputField(
                  controller: _passwordController,
                  hintText: l10n.enterYourPassword,
                  lable: l10n.password,
                  obscureText: true,
                  onChanged: (_) {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    auth.clearError();
                  },
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 6),
                Text(l10n.useAtLeast8, style: TextStyle(fontSize: 14, color: Colors.black54)),
                SizedBox(height: 12),
                // Confirm password input
                CustomTextInputField(
                  controller: _confirmPasswordController,
                  hintText: l10n.confirmYourPassword,
                  lable: l10n.confirmPassword,
                  obscureText: true,
                  onChanged: (_) {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    auth.clearError();
                  },
                  validator: _validateConfirmPassword,
                ),
                SizedBox(height: 48),

                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return CustomButton(
                      label: auth.loading ? l10n.signingUp : l10n.signUpTitle,
                      backgroundColor: Color(0xFF9B8572),
                      textColor: Colors.white,
                      onPressed: auth.loading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() != true) return;
                              final success = await auth.register(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text,
                              );
                              if (success) {
                                if (!context.mounted) return;
                                context.go(
                                  '${RouteNames.verificationPending}?email=${Uri.encodeComponent(_emailController.text.trim())}',
                                );
                              } else if (auth.error != null) {
                                AppFeedback.showErrorSheet(auth.error!);
                              }
                            },
                    );
                  },
                ),
                SizedBox(height: 12),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.alreadyHaveAccount,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/login');
                        },
                        child: Text(
                          l10n.signIn,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8B6F47),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
