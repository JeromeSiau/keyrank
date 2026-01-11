import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/integrations_provider.dart';

class ConnectGooglePlayScreen extends ConsumerStatefulWidget {
  const ConnectGooglePlayScreen({super.key});

  @override
  ConsumerState<ConnectGooglePlayScreen> createState() =>
      _ConnectGooglePlayScreenState();
}

class _ConnectGooglePlayScreenState
    extends ConsumerState<ConnectGooglePlayScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceAccountController = TextEditingController();
  final _packageNamesController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _serviceAccountController.dispose();
    _packageNamesController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (!_formKey.currentState!.validate()) return;

    final packageNames = _packageNamesController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (packageNames.isEmpty) {
      setState(() => _error = 'Please enter at least one package name');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result =
          await ref.read(integrationsProvider.notifier).connectGooglePlay(
                serviceAccountJson: _serviceAccountController.text.trim(),
                packageNames: packageNames,
              );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected! Imported ${result.appsImported} apps.'),
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
        title: const Text('Connect Google Play Console'),
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
                    controller: _serviceAccountController,
                    label: 'Service Account JSON',
                    hint: '{\n  "type": "service_account",\n  ...\n}',
                    helperText:
                        'Paste the entire contents of your service account JSON file',
                    isDark: isDark,
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Service account JSON is required';
                      }
                      if (!value.contains('"type"') ||
                          !value.contains('service_account')) {
                        return 'Invalid service account JSON format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _packageNamesController,
                    label: 'Package Names',
                    hint: 'com.example.app1\ncom.example.app2',
                    helperText: 'Enter one package name per line',
                    isDark: isDark,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'At least one package name is required';
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
                'How to get your service account',
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
            '1. Go to Google Cloud Console > IAM & Admin > Service Accounts\n'
            '2. Create a new service account\n'
            '3. Grant "Service Account User" role\n'
            '4. Create a JSON key and download it\n'
            '5. In Play Console, add this service account email with "View app information" access',
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
            fontFamily: 'monospace',
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
