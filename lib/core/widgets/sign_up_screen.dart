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

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  bool _isLoading = false;
  bool _obscurePassword = true;
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2), // Blue gradient top
              Colors.white, // White bottom
            ],
            stops: [0.4, 0.4],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Top Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "Already have an account?",
                          style: FontUtil.bodyMedium(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
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

                  // Jobsly Logo
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

                  // Sign Up Form
                  _buildSignUpForm(),

                  const SizedBox(height: 40),

                  // Social Sign Up
                  _buildSocialSignUp(),

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
      children: [
        // Email Field
        _buildTextField(
          controller: _emailController,
          hintText: 'Enter your email',
          labelText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        // Name Field
        _buildTextField(
          controller: _nameController,
          hintText: 'Enter your name',
          labelText: 'Your name',
        ),

        const SizedBox(height: 20),

        // Password Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: FontUtil.bodyMedium(
                color: Colors.grey[600],
                fontWeight: FontWeights.medium,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: FontUtil.bodyLarge(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: FontUtil.bodyLarge(
                  color: Colors.grey[400],
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Strong',
                        style: FontUtil.bodySmall(
                          color: Colors.green[700],
                          fontWeight: FontWeights.medium,
                        ),
                      ),
                    ),
                  ],
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF4A90E2)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Terms and Conditions
        _buildTermsCheckbox(),

        const SizedBox(height: 32),

        // Sign Up Button
        _buildButton(
          text: 'Sign up',
          onPressed: _isLoading ? null : _signUp,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: FontUtil.bodyMedium(
            color: Colors.grey[600],
            fontWeight: FontWeights.medium,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: FontUtil.bodyLarge(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: FontUtil.bodyLarge(
              color: Colors.grey[400],
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4A90E2)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: FontUtil.headlineSmall(
                  fontWeight: FontWeights.semiBold,
                ),
              ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: CheckboxListTile(
        value: _agreeToTerms,
        onChanged: (value) {
          setState(() {
            _agreeToTerms = value ?? false;
          });
        },
        title: Text(
          'I agree to the Terms of Service and Privacy Policy',
          style: FontUtil.bodyMedium(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        checkColor: const Color(0xFF8B5CF6),
        activeColor: Colors.white.withValues(alpha: 0.2),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildSocialSignUp() {
    return Column(
      children: [
        Text(
          'Or sign up with',
          style: FontUtil.bodyMedium(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata,
              label: 'Google',
              onPressed: _signUpWithGoogle,
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              icon: Icons.facebook,
              label: 'Facebook',
              onPressed: () {
                Get.snackbar(
                  'Facebook Sign Up',
                  'Coming soon!',
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: label == 'Google' ? Colors.red : Colors.blue, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: FontUtil.bodyMedium(
              color: Colors.black,
              fontWeight: FontWeights.medium,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _signUp() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Mock sign up - replace with real authentication
      await Future.delayed(const Duration(seconds: 2));

      // Store user data
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google Sign Up failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
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

    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!_agreeToTerms) {
      Get.snackbar(
        'Error',
        'Please agree to the Terms of Service',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}