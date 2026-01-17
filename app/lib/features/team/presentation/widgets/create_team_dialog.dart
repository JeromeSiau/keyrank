import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/team_provider.dart';

class CreateTeamDialog extends ConsumerStatefulWidget {
  const CreateTeamDialog({super.key});

  @override
  ConsumerState<CreateTeamDialog> createState() => _CreateTeamDialogState();
}

class _CreateTeamDialogState extends ConsumerState<CreateTeamDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      backgroundColor: isDark ? AppColors.bgSurface : AppColorsLight.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      title: Text(
        l10n.team_createTeam,
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.team_teamName,
                hintText: l10n.team_teamNameHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.team_teamNameRequired;
                }
                if (value.length < 2) {
                  return l10n.team_teamNameMinLength;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.team_description,
                hintText: l10n.team_descriptionHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text(
            l10n.common_cancel,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _createTeam,
          style: FilledButton.styleFrom(
            backgroundColor: isDark ? AppColors.accent : AppColorsLight.accent,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.team_createTeam),
        ),
      ],
    );
  }

  Future<void> _createTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final team = await ref.read(teamNotifierProvider.notifier).createTeam(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (team != null && mounted) {
      Navigator.of(context).pop(true);
    }
  }
}
