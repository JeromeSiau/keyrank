import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/integrations_provider.dart';

class ConnectAppStoreScreen extends ConsumerStatefulWidget {
  const ConnectAppStoreScreen({super.key});

  @override
  ConsumerState<ConnectAppStoreScreen> createState() =>
      _ConnectAppStoreScreenState();
}

class _ConnectAppStoreScreenState extends ConsumerState<ConnectAppStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keyIdController = TextEditingController();
  final _issuerIdController = TextEditingController();
  final _privateKeyController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _keyIdController.dispose();
    _issuerIdController.dispose();
    _privateKeyController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result =
          await ref.read(integrationsProvider.notifier).connectAppStore(
                keyId: _keyIdController.text.trim(),
                issuerId: _issuerIdController.text.trim(),
                privateKey: _privateKeyController.text.trim(),
              );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Connected! Imported ${result.appsImported} of ${result.appsDiscovered} apps.',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: const Text('Connect App Store Connect'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(isDark),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _keyIdController,
                    label: 'Key ID',
                    hint: 'e.g., ABC123DEFG',
                    helperText:
                        '10-character identifier from App Store Connect',
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Key ID is required';
                      }
                      if (value.length != 10) {
                        return 'Key ID must be exactly 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _issuerIdController,
                    label: 'Issuer ID',
                    hint: 'e.g., 12345678-1234-1234-1234-123456789012',
                    helperText: 'UUID from App Store Connect API Keys page',
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Issuer ID is required';
                      }
                      final uuidRegex = RegExp(
                        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
                        caseSensitive: false,
                      );
                      if (!uuidRegex.hasMatch(value)) {
                        return 'Invalid Issuer ID format (must be UUID)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _privateKeyController,
                    label: 'Private Key (.p8)',
                    hint:
                        '-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----',
                    helperText: 'Paste the entire contents of your .p8 file',
                    isDark: isDark,
                    maxLines: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Private key is required';
                      }
                      if (!value.contains('-----BEGIN PRIVATE KEY-----')) {
                        return 'Invalid private key format';
                      }
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.red : AppColorsLight.red)
                            .withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: (isDark ? AppColors.red : AppColorsLight.red)
                              .withAlpha(50),
                        ),
                      ),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.red : AppColorsLight.red,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _connect,
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Connect'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.glassPanelAlpha
            : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: isDark ? AppColors.accent : AppColorsLight.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'How to get your API credentials',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColorsLight.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '1. Go to App Store Connect > Users and Access > Keys\n'
            '2. Click "+" to generate a new API key\n'
            '3. Select "Admin" or "App Manager" access\n'
            '4. Download the .p8 file (only available once!)\n'
            '5. Copy the Key ID and Issuer ID from the page',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColorsLight.textSecondary,
              height: 1.6,
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
    required String helperText,
    required bool isDark,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            fontFamily: maxLines > 1 ? 'monospace' : null,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            helperMaxLines: 2,
            filled: true,
            fillColor: isDark
                ? AppColors.glassPanelAlpha
                : AppColorsLight.glassPanelAlpha,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color:
                    isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color:
                    isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
