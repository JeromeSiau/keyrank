import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/keyrank_logo.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    await ref.read(authStateProvider.notifier).register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
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
        _error = context.l10n.auth_errorOccurred;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                textColor: AppColors.textPrimary,
              ),
              const SizedBox(height: 40),
              // Register form card
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
                        Text(
                          l10n.auth_createAccount,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.auth_createAccountSubtitle,
                          style: const TextStyle(
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

                        // Name field
                        _buildTextField(
                          controller: _nameController,
                          label: l10n.auth_nameLabel,
                          icon: Icons.person_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.auth_nameRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email field
                        _buildTextField(
                          controller: _emailController,
                          label: l10n.auth_emailLabel,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.auth_emailRequired;
                            }
                            if (!value.contains('@')) {
                              return l10n.auth_emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        _buildTextField(
                          controller: _passwordController,
                          label: l10n.auth_passwordLabel,
                          icon: Icons.lock_outlined,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.auth_enterPassword;
                            }
                            if (value.length < 8) {
                              return l10n.auth_passwordMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Confirm password field
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: l10n.auth_confirmPasswordLabel,
                          icon: Icons.lock_outlined,
                          obscureText: true,
                          onSubmitted: (_) => _submit(),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return l10n.auth_passwordsNoMatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Register button
                        _buildPrimaryButton(
                          label: l10n.auth_signUpButton,
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 20),

                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.auth_hasAccount,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Text(
                                l10n.auth_signInLink,
                                style: const TextStyle(
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
