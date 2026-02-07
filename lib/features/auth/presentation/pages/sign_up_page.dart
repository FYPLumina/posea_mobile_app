import 'package:flutter/material.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/index.dart';
import 'package:go_router/go_router.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                      'Sign Up',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Error message
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      if (auth.error != null && auth.error!.isNotEmpty) {
                        return Center(
                          child: Text(auth.error!, style: TextStyle(color: Colors.red)),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  // Name input
                  CustomTextInputField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    lable: 'Name',
                    validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                  ),
                  SizedBox(height: 12),
                  // Email input
                  CustomTextInputField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    lable: 'Email',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter your email' : null,
                  ),
                  SizedBox(height: 12),
                  // Password input
                  CustomTextInputField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    lable: 'Password',
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter your password' : null,
                  ),
                  SizedBox(height: 12),
                  // Confirm password input
                  CustomTextInputField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm your password',
                    lable: 'Confirm Password',
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Confirm your password' : null,
                  ),
                  SizedBox(height: 24),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return CustomButton(
                        label: auth.loading ? 'Signing Up...' : 'Sign Up',
                        backgroundColor: Color(0xFF9B8572),
                        textColor: Colors.white,
                        onPressed: auth.loading
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() != true) return;
                                if (_passwordController.text != _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
                                  return;
                                }
                                await auth.register(
                                  _nameController.text.trim(),
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                );
                                if (auth.error == null &&
                                    auth.token != null &&
                                    auth.loading == false) {
                                  context.go('/login');
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
                          'Already have an account? ',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/login');
                          },
                          child: Text(
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
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: Divider(thickness: 1, color: Color(0xFFDED6CC))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('OR', style: TextStyle(color: Colors.black54)),
                      ),
                      Expanded(child: Divider(thickness: 1, color: Color(0xFFDED6CC))),
                    ],
                  ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: SocialLoginButton(
                          label: 'Google',
                          onPressed: () {},
                          iconPath: 'assets/icons/google-coloured-icon.png',
                          backgroundColor: Color(0xFF9B8572),
                          textColor: Colors.white,
                          width: 120,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: SocialLoginButton(
                          label: 'Facebook',
                          onPressed: () {},
                          iconPath: 'assets/icons/Facebook-coloured-icon.png',
                          backgroundColor: Color(0xFF9B8572),
                          textColor: Colors.white,
                          width: 120,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // All widgets must be inside the build method's return statement. If you want to add the trailing widgets (Row, SizedBox, SocialLoginButton, etc.), place them inside the main widget tree above, e.g. as children of a Column or ListView.
}
