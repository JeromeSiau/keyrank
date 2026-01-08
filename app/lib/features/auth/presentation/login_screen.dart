import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/keyrank_logo.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    await ref.read(authStateProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    final authState = ref.read(authStateProvider);

    if (authState.hasValue && authState.value != null) {
      context.go('/dashboard');
    } else if (authState.hasError) {
      setState(() {
        _error = authState.error.toString();
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = 'An error occurred';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const KeyrankLogoStacked(
                iconSize: 64,
                fontSize: 26,
                tagline: 'Track your App Store rankings',
                textColor: AppColors.textPrimary,
              ),
              const SizedBox(height: 40),
              // Login form card
              GlassContainer(
                radius: AppColors.radiusLarge,
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        // Error message
                        if (_error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.redMuted,
                              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                              border: Border.all(color: AppColors.red.withAlpha(50)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, size: 18, color: AppColors.red),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(
                                      color: AppColors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Email field
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outlined,
                          obscureText: true,
                          onSubmitted: (_) => _submit(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        _buildPrimaryButton(
                          label: 'Sign in',
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 20),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/register'),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.bgBase,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            errorStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

