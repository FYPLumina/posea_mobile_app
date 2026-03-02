import 'package:flutter/material.dart';
import '../../../../core/widgets/index.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.resetPassword,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B6F47),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.resetPasswordDescription,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              CustomTextInputField(
                hintText: l10n.enterYourEmail,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const Spacer(),
              CustomButton(
                onPressed: auth.loading
                    ? null
                    : () async {
                        final email = _emailController.text.trim();
                        if (email.isEmpty) {
                          await AppFeedback.showErrorSheet(l10n.pleaseEnterYourEmail);
                          return;
                        }

                        final success = await auth.forgotPassword(email);
                        if (!context.mounted) return;

                        if (!success &&
                            auth.error != null &&
                            auth.error!.toLowerCase().contains('timeout')) {
                          await AppFeedback.showErrorSheet(l10n.networkTimeoutTryAgain);
                          return;
                        }

                        await AppFeedback.showSuccessSheet(
                          l10n.resetLinkSent,
                          l10n.resetLinkSentDescription,
                          actionText: l10n.resetPassword,
                          onAction: () => context.push(RouteNames.resetPassword),
                        );
                      },
                label: auth.loading ? l10n.requesting : l10n.requestPasswordReset,
                backgroundColor: const Color(0xFF9B8572),
                textColor: Colors.white,
              ),
              const SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.haveResetToken,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(RouteNames.resetPassword);
                      },
                      child: Text(
                        l10n.resetNow,
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
              const SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.rememberPassword,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(RouteNames.login);
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
            ],
          ),
        ),
      ),
    );
  }
}
