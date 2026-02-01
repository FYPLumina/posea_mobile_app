import 'package:flutter/material.dart';
import '../../../../core/widgets/index.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: const [
                      Text(
                        'Create your Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B6F47),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Login in to capturing your moments',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
                const Text(
                  'Full Name',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                ),
                const SizedBox(height: 6),
                const CustomTextInputField(hintText: 'Enter your Full Name'),
                const SizedBox(height: 16),
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
                const CustomTextInputField(hintText: 'Enter your Password', obscureText: true),
                const SizedBox(height: 16),
                const Text(
                  'Confirm Password',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                ),
                const SizedBox(height: 6),
                const CustomTextInputField(hintText: 'Confirm password', obscureText: true),
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: () {},
                  label: 'Sign In',
                  backgroundColor: const Color(0xFF9B8572),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 12),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/login');
                        },
                        child: const Text(
                          'Sign in',
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
                const SizedBox(height: 18),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1, color: Color(0xFFDED6CC))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('OR', style: TextStyle(color: Colors.black54)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Color(0xFFDED6CC))),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SocialLoginButton(
                        label: 'Google',
                        onPressed: () {},
                        iconPath: 'assets/icons/google-coloured-icon.png',
                        backgroundColor: const Color(0xFF9B8572),
                        textColor: Colors.white,
                        width: 120,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SocialLoginButton(
                        label: 'Facebook',
                        onPressed: () {},
                        iconPath: 'assets/icons/Facebook-coloured-icon.png',
                        backgroundColor: const Color(0xFF9B8572),
                        textColor: Colors.white,
                        width: 120,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
