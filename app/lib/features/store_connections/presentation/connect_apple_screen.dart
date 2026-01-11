import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/store_connections_provider.dart';

class ConnectAppleScreen extends ConsumerStatefulWidget {
  const ConnectAppleScreen({super.key});

  @override
  ConsumerState<ConnectAppleScreen> createState() => _ConnectAppleScreenState();
}

class _ConnectAppleScreenState extends ConsumerState<ConnectAppleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuerIdController = TextEditingController();
  final _keyIdController = TextEditingController();
  final _privateKeyController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _issuerIdController.dispose();
    _keyIdController.dispose();
    _privateKeyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(storeConnectionsProvider.notifier).connectIOS(
            name: _nameController.text.trim(),
            issuerId: _issuerIdController.text.trim(),
            keyId: _keyIdController.text.trim(),
            privateKey: _privateKeyController.text.trim(),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('App Store Connect connected successfully!')),
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
        title: const Text('Connect App Store'),
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
                          'How to get your API Key',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep('1', 'Go to App Store Connect > Users and Access > Keys', textSecondary),
                    _buildInstructionStep('2', 'Click the + button to create a new API key', textSecondary),
                    _buildInstructionStep('3', 'Give it a name and select "Admin" access', textSecondary),
                    _buildInstructionStep('4', 'Copy the Issuer ID (shown at the top)', textSecondary),
                    _buildInstructionStep('5', 'Copy the Key ID from the table', textSecondary),
                    _buildInstructionStep('6', 'Download the .p8 file and paste its contents below', textSecondary),
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
                hint: 'e.g., My App Store Account',
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
                controller: _issuerIdController,
                label: 'Issuer ID',
                hint: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                isDark: isDark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Issuer ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _keyIdController,
                label: 'Key ID',
                hint: 'XXXXXXXXXX',
                isDark: isDark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Key ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _privateKeyController,
                label: 'Private Key',
                hint: '-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----',
                isDark: isDark,
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the private key';
                  }
                  if (!value.contains('BEGIN PRIVATE KEY')) {
                    return 'Invalid private key format';
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
                          'Connect App Store',
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
          maxLines: maxLines,
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
