import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/team_model.dart';
import '../../providers/team_provider.dart';

class InviteMemberDialog extends ConsumerStatefulWidget {
  final int teamId;

  const InviteMemberDialog({super.key, required this.teamId});

  @override
  ConsumerState<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends ConsumerState<InviteMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  TeamRole _selectedRole = TeamRole.viewer;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.bgSurface : AppColorsLight.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      title: Text(
        'Invite Team Member',
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'colleague@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Role',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...TeamRole.values
                .where((role) => role != TeamRole.owner)
                .map((role) => _RoleOption(
                      role: role,
                      isSelected: _selectedRole == role,
                      isDark: isDark,
                      onTap: () => setState(() => _selectedRole = role),
                    )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _sendInvitation,
          style: FilledButton.styleFrom(
            backgroundColor: isDark ? AppColors.accent : AppColorsLight.accent,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send Invite'),
        ),
      ],
    );
  }

  Future<void> _sendInvitation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final invitation = await ref.read(memberNotifierProvider.notifier).inviteMember(
      widget.teamId,
      email: _emailController.text.trim(),
      role: _selectedRole.name,
    );

    setState(() => _isLoading = false);

    if (invitation != null && mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation sent to ${_emailController.text}')),
      );
    }
  }
}

class _RoleOption extends StatelessWidget {
  final TeamRole role;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _RoleOption({
    required this.role,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? accent.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          border: Border.all(
            color: isSelected
                ? accent
                : (isDark ? AppColors.border : AppColorsLight.border),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: isSelected
                  ? accent
                  : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    ),
                  ),
                  Text(
                    role.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
