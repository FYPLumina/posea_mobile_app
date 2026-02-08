import 'dart:async';
import 'package:flutter/material.dart';
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
      context.go('/home');
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
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Continue capturing your moments',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      CustomTextInputField(
                        hintText: 'Enter your Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Password',
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      CustomTextInputField(
                        hintText: 'Enter your password',
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.push('/forgot-password');
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Text(
                            'Forgot password?',
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
                              if (auth.error != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    auth.error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              CustomButton(
                                onPressed: auth.loading
                                    ? null
                                    : () async {
                                        await _handleLogin(auth);
                                      },
                                label: auth.loading ? 'Logging in...' : 'Login',
                                backgroundColor: const Color(0xFF8B6F47),
                                textColor: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              CustomButton(
                                onPressed: () {},
                                label: 'Continue as guest',
                                isBordered: true,
                                backgroundColor: Colors.white,
                                textColor: const Color(0xFF9B8572),
                                borderColor: const Color(0xFF9B8572),
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Don't have an account? ",
                                      style: TextStyle(fontSize: 13, color: Colors.black54),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.push('/register');
                                      },
                                      child: const Text(
                                        'Sign up',
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
