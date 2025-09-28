// core/widgets/sign_in_screen.dart
import 'package:day_os/core/theme/font_util.dart';
import 'package:day_os/core/utils/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5B7CFA), // Purple-blue
              Color(0xFF4A6CF7), // Blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Top navigation row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      child: Text(
                        "Don't have an account?",
                        style: FontUtil.bodyMedium(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        "Get Started",
                        style: FontUtil.bodyMedium(
                          color: Colors.white,
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Logo
                Text(
                  "DailyOS",
                  style: FontUtil.displayLarge(
                    color: Colors.white,
                    fontWeight: FontWeights.bold,
                  ),
                ),

                const SizedBox(height: 60),

                // White form container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: FontUtil.headlineMedium(
                          fontWeight: FontWeights.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Enter your details below",
                        style: FontUtil.bodyMedium(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 32),

                      // Email field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Sign In Button (Gradient)
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B7CFA), Color(0xFFE07AFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Sign in",
                                  style: FontUtil.headlineSmall(
                                    color: Colors.white,
                                    fontWeight: FontWeights.semiBold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Forgot Password
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot your password?",
                            style: FontUtil.bodyMedium(
                              color: const Color(0xFF4A6CF7),
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Or sign in with",
                              style: FontUtil.bodyMedium(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social Buttons
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _signInWithGoogle,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/google.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Google",
                                      style: FontUtil.bodyMedium(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1877F2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.facebook,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Facebook",
                                      style: FontUtil.bodyMedium(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      final storage = GetStorage();
      storage.write('user_email', _emailController.text);
      storage.write('user_name', _emailController.text.split('@')[0]);
      storage.write('is_authenticated', true);
      Get.offAllNamed('/');
    } catch (e) {
      Get.snackbar(
        'Sign In Failed',
        'Please try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        final storage = GetStorage();
        storage.write('is_authenticated', true);
        storage.write('auth_method', 'google');
        Get.offAllNamed('/');
      } else {
        Get.snackbar(
          'Google Sign In Failed',
          'Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
