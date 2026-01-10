import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../apps/domain/app_model.dart';
import '../../../apps/providers/apps_provider.dart';

class CompareAppSelectorModal extends ConsumerStatefulWidget {
  final int currentAppId;
  final String currentAppName;
  final void Function(List<int> selectedAppIds) onCompare;

  const CompareAppSelectorModal({
    super.key,
    required this.currentAppId,
    required this.currentAppName,
    required this.onCompare,
  });

  @override
  ConsumerState<CompareAppSelectorModal> createState() => _CompareAppSelectorModalState();
}

class _CompareAppSelectorModalState extends ConsumerState<CompareAppSelectorModal> {
  final Set<int> _selectedIds = {};
  String _searchQuery = '';

  List<AppModel> _getFilteredApps(List<AppModel> apps) {
    return apps
        .where((app) => app.id != widget.currentAppId)
        .where((app) => _searchQuery.isEmpty ||
            app.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleSelection(int appId) {
    setState(() {
      if (_selectedIds.contains(appId)) {
        _selectedIds.remove(appId);
      } else if (_selectedIds.length < 3) {
        _selectedIds.add(appId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appsAsync = ref.watch(appsNotifierProvider);

    return Dialog(
      backgroundColor: AppColors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: SizedBox(
        width: 500,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: appsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (apps) => _buildAppsList(_getFilteredApps(apps)),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.compare_arrows_rounded, size: 20, color: AppColors.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.insights_compareTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.compare_selectAppsToCompare(widget.currentAppName),
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgBase,
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: context.l10n.compare_searchApps,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildAppsList(List<AppModel> apps) {
    if (apps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted.withAlpha(100)),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isEmpty ? context.l10n.compare_noOtherApps : context.l10n.compare_noMatchingApps,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        final isSelected = _selectedIds.contains(app.id);
        final isDisabled = !isSelected && _selectedIds.length >= 3;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : () => _toggleSelection(app.id),
            hoverColor: AppColors.bgHover,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentMuted : Colors.transparent,
              ),
              child: Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: isSelected,
                    onChanged: isDisabled ? null : (_) => _toggleSelection(app.id),
                    activeColor: AppColors.accent,
                    side: BorderSide(
                      color: isDisabled ? AppColors.textMuted.withAlpha(50) : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // App icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.bgActive,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: app.iconUrl != null
                        ? Image.network(app.iconUrl!, fit: BoxFit.cover)
                        : Icon(
                            app.isIos ? Icons.apple : Icons.android,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                  ),
                  const SizedBox(width: 12),
                  // App name and platform
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDisabled
                                ? AppColors.textMuted.withAlpha(100)
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          app.isIos ? 'iOS' : 'Android',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDisabled
                                ? AppColors.textMuted.withAlpha(50)
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.compare_appsSelected(_selectedIds.length),
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.compare_cancel),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: _selectedIds.isEmpty
                ? null
                : () {
                    Navigator.of(context).pop();
                    widget.onCompare(_selectedIds.toList());
                  },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              disabledBackgroundColor: AppColors.accentMuted,
            ),
            child: Text(context.l10n.compare_button(_selectedIds.length + 1)),
          ),
        ],
      ),
    );
  }
}
