import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/core/widgets/custom_button.dart';
import 'package:posea_mobile_app/core/widgets/custom_text_input_field.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';

class VerificationPendingPage extends StatefulWidget {
  const VerificationPendingPage({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<VerificationPendingPage> createState() => _VerificationPendingPageState();
}

class _VerificationPendingPageState extends State<VerificationPendingPage> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _emailController = TextEditingController(text: widget.initialEmail ?? auth.pendingEmail ?? '');
  }

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
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.verifyYourEmail,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B6F47),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.verifyEmailDescription,
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
                label: auth.loading ? l10n.sending : l10n.sendVerificationEmail,
                backgroundColor: const Color(0xFF9B8572),
                textColor: Colors.white,
                onPressed: auth.loading
                    ? null
                    : () async {
                        final email = _emailController.text.trim();
                        if (email.isEmpty) {
                          await AppFeedback.showErrorSheet(l10n.pleaseEnterYourEmail);
                          return;
                        }
                        auth.setPendingEmail(email);
                        final success = await auth.resendVerificationEmail(email);
                        if (!context.mounted) return;
                        if (success) {
                          await AppFeedback.showSuccessSheet(
                            l10n.emailSent,
                            l10n.emailSentDescription,
                          );
                        } else if (auth.error != null) {
                          await AppFeedback.showErrorSheet(auth.error!);
                        }
                      },
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: l10n.verifyNow,
                backgroundColor: Colors.white,
                textColor: const Color(0xFF8B6F47),
                onPressed: () => context.go(RouteNames.verifyEmail),
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: l10n.alreadyVerified,
                backgroundColor: Colors.white,
                textColor: const Color(0xFF8B6F47),
                onPressed: () => context.go(RouteNames.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
