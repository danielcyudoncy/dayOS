// core/widgets/forgot_password_screen.dart
import 'package:day_os/core/theme/font_util.dart';
import 'package:day_os/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  bool _isLoading = false;
  bool _autoValidate = false;
  bool _emailSent = false;

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
              Color.fromARGB(255, 104, 16, 186), // Purple-blue
              Color(0xFF4A6CF7), // Blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Top section with navigation and logo
            SafeArea(
              child: Padding(
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
                            Get.back();
                          },
                          child: Text(
                            "Back to Sign In",
                            style: FontUtil.bodySmall(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            "Sign In",
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
                  ],
                ),
              ),
            ),

            // Background white container (faded)
            Positioned(
              left: 20,
              right: 20,
              bottom: 0,
              top: 280, // Raised top position for background
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3), // Reduced opacity
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),

            // Main white form container - Positioned to cover bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 300, // Original top position for main container
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),

                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Forgot Password",
                            style: FontUtil.headlineMedium(
                              fontWeight: FontWeights.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: Text(
                            _emailSent
                              ? "Password reset email sent! Check your inbox (and spam folder)"
                              : "Enter your email address and we'll send you a link to reset your password",
                            style: FontUtil.bodyMedium(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),

                        if (!_emailSent) ...[
                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF5B7CFA), width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Send Reset Email Button (Gradient)
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
                              onPressed: _isLoading ? null : _sendResetEmail,
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
                                      "Send Reset Email",
                                      style: FontUtil.headlineSmall(
                                        color: Colors.white,
                                        fontWeight: FontWeights.semiBold,
                                      ),
                                    ),
                            ),
                          ),
                        ] else ...[
                          // Success state
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  color: Colors.green,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Email Sent!",
                                  style: FontUtil.headlineSmall(
                                    color: Colors.green,
                                    fontWeight: FontWeights.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "We've sent password reset instructions to:",
                                  style: FontUtil.bodyMedium(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _emailController.text,
                                  style: FontUtil.bodyLarge(
                                    color: Colors.black,
                                    fontWeight: FontWeights.medium,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Didn't receive the email? Check your spam folder, or the email might be in your other email folders.",
                                  style: FontUtil.bodySmall(color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Back to Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B7CFA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                "Back to Sign In",
                                style: FontUtil.headlineSmall(
                                  color: Colors.white,
                                  fontWeight: FontWeights.semiBold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Try Different Email Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _emailSent = false;
                                  _emailController.clear();
                                });
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Try Different Email",
                                style: FontUtil.bodyLarge(
                                  color: const Color(0xFF5B7CFA),
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Help text
                        if (!_emailSent) ...[
                          Center(
                            child: Text(
                              "Remember your password?",
                              style: FontUtil.bodyMedium(color: Colors.grey[600]),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                "Sign In",
                                style: FontUtil.bodyMedium(
                                  color: const Color(0xFF4A6CF7),
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _sendResetEmail() async {
    setState(() => _autoValidate = true);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await _authController.sendPasswordResetEmail(_emailController.text);

      if (success) {
        setState(() => _emailSent = true);
      }
    } catch (e) {
      print('Forgot password error: $e');
      Get.snackbar(
        'Reset Failed',
        'Unable to send reset email. Please check your email address and try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}