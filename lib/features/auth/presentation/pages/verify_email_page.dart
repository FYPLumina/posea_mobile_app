import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/core/widgets/custom_button.dart';
import 'package:posea_mobile_app/core/widgets/custom_text_input_field.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, this.initialToken, this.initialEmail});

  final String? initialToken;
  final String? initialEmail;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late final TextEditingController _tokenController;
  bool _hasTriedAutoVerify = false;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((widget.initialToken ?? '').trim().isNotEmpty && !_hasTriedAutoVerify) {
        _hasTriedAutoVerify = true;
        _verifyToken();
      }
    });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _verifyToken() async {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = _tokenController.text.trim();

    if (token.isEmpty) {
      await AppFeedback.showErrorSheet(l10n.pleaseEnterVerificationToken);
      return;
    }

    final success = await auth.verifyEmailToken(token);
    if (!mounted) return;

    if (success) {
      await AppFeedback.showSuccessSheet(
        l10n.emailVerified,
        l10n.emailVerifiedDescription,
        actionText: l10n.signIn,
        onAction: () => context.go(RouteNames.login),
      );
    } else if (auth.error != null) {
      await AppFeedback.showErrorSheet(auth.error!);
    }
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
                l10n.verifyEmail,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B6F47),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.verifyTokenDescription,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              CustomTextInputField(
                hintText: l10n.enterVerificationToken,
                controller: _tokenController,
              ),
              const Spacer(),
              CustomButton(
                label: auth.loading ? l10n.verifying : l10n.verifyEmail,
                backgroundColor: const Color(0xFF9B8572),
                textColor: Colors.white,
                onPressed: auth.loading ? null : _verifyToken,
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: l10n.resendVerificationEmail,
                backgroundColor: Colors.white,
                textColor: const Color(0xFF8B6F47),
                onPressed: () {
                  final email = widget.initialEmail ?? auth.pendingEmail ?? '';
                  context.go(
                    '${RouteNames.verificationPending}?email=${Uri.encodeComponent(email)}',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
