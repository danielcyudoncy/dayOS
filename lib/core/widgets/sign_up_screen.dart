// core/widgets/sign_up_screen.dart
import 'package:day_os/core/theme/font_util.dart';
import 'package:day_os/core/utils/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5B7CFA), Color(0xFF4A6CF7)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Top Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "Already have an account?",
                          style: FontUtil.bodyMedium(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Get.back(),
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
                          "Sign in",
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
                  Center(
                    child: Text(
                      'DailyOS',
                      style: FontUtil.displayLarge(
                        color: Colors.white,
                        fontWeight: FontWeights.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // White Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _buildSignUpForm(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create Account",
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

        // Name
        _buildTextField(controller: _nameController, labelText: "Full Name"),
        const SizedBox(height: 16),

        // Email
        _buildTextField(
          controller: _emailController,
          labelText: "Email Address",
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        // Password
        _buildPasswordTextField(
          controller: _passwordController,
          labelText: "Password",
          obscureText: _obscurePassword,
          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: 16),

        // Confirm Password
        _buildPasswordTextField(
          controller: _confirmPasswordController,
          labelText: "Confirm Password",
          obscureText: _obscureConfirmPassword,
          onToggle: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
        const SizedBox(height: 24),

        // Terms
        _buildTermsCheckbox(),
        const SizedBox(height: 32),

        // Sign Up Button
        _buildButton(
          text: 'Sign up',
          onPressed: _isLoading ? null : _signUp,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 24),

        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300]!)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Or sign up with",
                style: FontUtil.bodyMedium(color: Colors.grey[600]),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300]!)),
          ],
        ),
        const SizedBox(height: 24),

        // Social Buttons
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _signUpWithGoogle,
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
                        style: FontUtil.bodyMedium(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.snackbar(
                    'Facebook',
                    'Coming soon!',
                    backgroundColor: Colors.white,
                    colorText: Colors.black,
                  );
                },
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
                      const Icon(Icons.facebook, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Facebook",
                        style: FontUtil.bodyMedium(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
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
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
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
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          activeColor: const Color(0xFF5B7CFA),
          onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'I agree to the ',
                  style: FontUtil.bodyMedium(color: Colors.grey[700]),
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: FontUtil.bodyMedium(
                    color: const Color(0xFF5B7CFA),
                    fontWeight: FontWeights.semiBold,
                  ),
                ),
                TextSpan(
                  text: ' and ',
                  style: FontUtil.bodyMedium(color: Colors.grey[700]),
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: FontUtil.bodyMedium(
                    color: const Color(0xFF5B7CFA),
                    fontWeight: FontWeights.semiBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return Container(
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: FontUtil.headlineSmall(
                  color: Colors.white,
                  fontWeight: FontWeights.semiBold,
                ),
              ),
      ),
    );
  }

  // --- Logic ---
  bool _validateForm() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(_emailController.text)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (_passwordController.text.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 6 characters',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!_agreeToTerms) {
      Get.snackbar(
        'Terms Required',
        'Please agree to the Terms of Service',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> _signUp() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 2)); // Replace with real API
      final storage = GetStorage();
      storage.write('user_email', _emailController.text);
      storage.write('user_name', _nameController.text);
      storage.write('is_authenticated', true);
      Get.offAllNamed('/');
    } catch (e) {
      Get.snackbar(
        'Sign Up Failed',
        'Please try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithGoogle() async {
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
          'Google Sign Up Failed',
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
