import 'dart:async';
import 'package:flutter/material.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/core/utils/app_feedback.dart';
import 'package:posea_mobile_app/core/utils/validators.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';
import '../../../../core/widgets/index.dart';
import 'package:provider/provider.dart';
import '../../application/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleLogin(AuthProvider auth) async {
    if (_formKey.currentState?.validate() != true) return;
    final success = await auth.login(_emailController.text.trim(), _passwordController.text);
    if (success) {
      context.go(RouteNames.home);
      return;
    }

    if (!mounted) return;
    if (auth.authFlowState == AuthFlowState.verificationPending) {
      final email = auth.pendingEmail ?? _emailController.text.trim();
      context.push('${RouteNames.verificationPending}?email=${Uri.encodeComponent(email)}');
      return;
    }

    if (auth.error != null) {
      await AppFeedback.showErrorSheet(auth.error!);
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: [
              // Top image with curved bottom
              ClipPath(
                clipper: _CurvedBottomClipper(),
                child: Image.asset(
                  'assets/images/login-bg-image.png',
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          l10n.welcomeBack,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          l10n.continueCapturingMoments,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.email,
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      CustomTextInputField(
                        hintText: l10n.enterYourEmail,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) => Validators.validateEmail(value?.trim()),
                        onChanged: (_) {
                          final auth = Provider.of<AuthProvider>(context, listen: false);
                          auth.clearError();
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.password,
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      CustomTextInputField(
                        hintText: l10n.enterYourPassword,
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) => Validators.validateRequired(value, label: l10n.password),
                        onChanged: (_) {
                          final auth = Provider.of<AuthProvider>(context, listen: false);
                          auth.clearError();
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.push('/forgot-password');
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            l10n.forgotPasswordQuestion,
                            style: TextStyle(color: Color(0xFF8B6F47), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Builder(
                        builder: (context) {
                          final auth = Provider.of<AuthProvider>(context);
                          return Column(
                            children: [
                              CustomButton(
                                onPressed: auth.loading
                                    ? null
                                    : () async {
                                        await _handleLogin(auth);
                                      },
                                label: auth.loading
                                  ? l10n.loggingIn
                                  : l10n.login,
                                backgroundColor: const Color(0xFF8B6F47),
                                textColor: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      l10n.dontHaveAccount,
                                      style: TextStyle(fontSize: 13, color: Colors.black54),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.push('/register');
                                      },
                                      child: Text(
                                        l10n.signUp,
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
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height - 30);
    path.quadraticBezierTo(size.width * 0.75, size.height - 60, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
