import 'package:flutter/material.dart';
import '../../../../core/widgets/index.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                    const CustomTextInputField(
                      hintText: 'Enter your Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    const CustomTextInputField(hintText: 'Enter your password', obscureText: true),
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
                    const SizedBox(height: 8),
                    CustomButton(
                      onPressed: () {
                        // TODO: Add login logic here
                        // On successful login, route to home page
                        context.go('/home');
                      },
                      label: 'Sign In',
                      backgroundColor: const Color(0xFF9B8572),
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
