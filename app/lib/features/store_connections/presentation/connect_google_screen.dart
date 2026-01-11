import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/store_connections_provider.dart';

class ConnectGoogleScreen extends ConsumerStatefulWidget {
  const ConnectGoogleScreen({super.key});

  @override
  ConsumerState<ConnectGoogleScreen> createState() => _ConnectGoogleScreenState();
}

class _ConnectGoogleScreenState extends ConsumerState<ConnectGoogleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  final _refreshTokenController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _clientIdController.dispose();
    _clientSecretController.dispose();
    _refreshTokenController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(storeConnectionsProvider.notifier).connectAndroid(
            name: _nameController.text.trim(),
            clientId: _clientIdController.text.trim(),
            clientSecret: _clientSecretController.text.trim(),
            refreshToken: _refreshTokenController.text.trim(),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Play Console connected successfully!')),
      );
      context.pop();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondary : AppColorsLight.textSecondary;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;
    final red = isDark ? AppColors.red : AppColorsLight.red;
    final redMuted = isDark ? AppColors.redMuted : AppColorsLight.redMuted;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: const Text('Connect Google Play'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accent.withAlpha(15),
                  borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                  border: Border.all(color: accent.withAlpha(50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: accent),
                        const SizedBox(width: 8),
                        Text(
                          'How to set up Google OAuth',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep('1', 'Go to Google Cloud Console > APIs & Services > Credentials', textSecondary),
                    _buildInstructionStep('2', 'Create OAuth 2.0 Client ID (Web application type)', textSecondary),
                    _buildInstructionStep('3', 'Copy the Client ID and Client Secret', textSecondary),
                    _buildInstructionStep('4', 'Enable the Google Play Android Developer API', textSecondary),
                    _buildInstructionStep('5', 'Use the OAuth Playground to get a refresh token', textSecondary),
                    _buildInstructionStep('6', 'Authorize with scope: https://www.googleapis.com/auth/androidpublisher', textSecondary),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Error message
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: redMuted,
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    border: Border.all(color: red.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 18, color: red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: red, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Form fields
              _buildTextField(
                controller: _nameController,
                label: 'Connection Name',
                hint: 'e.g., My Google Play Account',
                isDark: isDark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a connection name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _clientIdController,
                label: 'Client ID',
                hint: 'xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com',
                isDark: isDark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Client ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _clientSecretController,
                label: 'Client Secret',
                hint: 'GOCSPX-xxxxxxxxxxxxxxxxxxxxxxxx',
                isDark: isDark,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Client Secret';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _refreshTokenController,
                label: 'Refresh Token',
                hint: '1//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                isDark: isDark,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Refresh Token';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Connect Google Play',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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

  Widget _buildInstructionStep(String number, String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.accent
                      : AppColorsLight.accent)
                  .withAlpha(25),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.accent
                    : AppColorsLight.accent,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    int maxLines = 1,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondary : AppColorsLight.textSecondary;
    final textMuted = isDark ? AppColors.textMuted : AppColorsLight.textMuted;
    final bgBase = isDark ? AppColors.bgBase : AppColorsLight.bgBase;
    final border = isDark ? AppColors.border : AppColorsLight.border;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;
    final red = isDark ? AppColors.red : AppColorsLight.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: obscureText ? 1 : maxLines,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            fontSize: 14,
            color: textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: textMuted),
            filled: true,
            fillColor: bgBase,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: BorderSide(color: accent, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: BorderSide(color: red),
            ),
            errorStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
