import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_context_provider.dart';
import '../theme/app_colors.dart';
import '../../features/apps/providers/apps_provider.dart';
import '../../features/apps/providers/sidebar_apps_provider.dart';
import '../../features/apps/domain/app_model.dart';

/// A dropdown widget for selecting the current app context.
/// When an app is selected, all screens filter data for that app.
/// When "All apps" is selected, screens show aggregate data.
class AppContextSwitcher extends ConsumerWidget {
  const AppContextSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApp = ref.watch(appContextProvider);
    final colors = context.colors;

    // Restore app context from persistence when apps are loaded
    final appsAsync = ref.watch(appsNotifierProvider);
    ref.listen<AsyncValue<List<AppModel>>>(appsNotifierProvider, (prev, next) {
      next.whenData((apps) {
        final notifier = ref.read(appContextProvider.notifier);
        if (!notifier.hasRestored) {
          notifier.restoreFromApps(apps);
        }
      });
    });
    // Also restore on initial build (ref.listen doesn't fire for initial value)
    appsAsync.whenData((apps) {
      final notifier = ref.read(appContextProvider.notifier);
      if (!notifier.hasRestored) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifier.restoreFromApps(apps);
        });
      }
    });

    return InkWell(
      onTap: () => _showAppPicker(context, ref),
      borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.bgSurface,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            if (selectedApp != null && selectedApp.iconUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  selectedApp.iconUrl!,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.apps,
                    size: 24,
                    color: colors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ] else ...[
              Icon(Icons.apps, size: 24, color: colors.textMuted),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                selectedApp?.name ?? 'All apps',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: colors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showAppPicker(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final sidebarApps = ref.read(sidebarAppsProvider);
    final selectedApp = ref.read(appContextProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    if (isDesktop) {
      // On desktop, show a dropdown popup below the switcher
      final RenderBox button = context.findRenderObject() as RenderBox;
      final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
      final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

      showMenu<dynamic>(
        context: context,
        position: RelativeRect.fromLTRB(
          position.dx,
          position.dy + button.size.height + 4,
          position.dx + button.size.width,
          position.dy + button.size.height + 400,
        ),
        color: colors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.border),
        ),
        constraints: BoxConstraints(
          minWidth: button.size.width,
          maxWidth: button.size.width,
          maxHeight: 400,
        ),
        items: [
          // All apps option
          PopupMenuItem<void>(
            onTap: () => ref.read(appContextProvider.notifier).select(null),
            child: _PopupAppTile(
              icon: Icons.apps,
              name: 'All apps',
              isSelected: selectedApp == null,
            ),
          ),
          const PopupMenuDivider(),
          // Favorites
          if (sidebarApps.favorites.isNotEmpty) ...[
            const PopupMenuItem<void>(
              enabled: false,
              height: 32,
              child: Text('Favorites', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            ...sidebarApps.favorites.map((app) => PopupMenuItem<void>(
              onTap: () => ref.read(appContextProvider.notifier).select(app),
              child: _PopupAppTile(
                iconUrl: app.iconUrl,
                name: app.name,
                isSelected: selectedApp?.id == app.id,
              ),
            )),
          ],
          // iOS
          if (sidebarApps.iosList.isNotEmpty) ...[
            const PopupMenuItem<void>(
              enabled: false,
              height: 32,
              child: Text('iPhone', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            ...sidebarApps.iosList.map((app) => PopupMenuItem<void>(
              onTap: () => ref.read(appContextProvider.notifier).select(app),
              child: _PopupAppTile(
                iconUrl: app.iconUrl,
                name: app.name,
                isSelected: selectedApp?.id == app.id,
              ),
            )),
          ],
          // Android
          if (sidebarApps.androidList.isNotEmpty) ...[
            const PopupMenuItem<void>(
              enabled: false,
              height: 32,
              child: Text('Android', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            ...sidebarApps.androidList.map((app) => PopupMenuItem<void>(
              onTap: () => ref.read(appContextProvider.notifier).select(app),
              child: _PopupAppTile(
                iconUrl: app.iconUrl,
                name: app.name,
                isSelected: selectedApp?.id == app.id,
              ),
            )),
          ],
          const PopupMenuDivider(),
          // Manage apps
          PopupMenuItem<void>(
            onTap: () => context.go('/apps/manage'),
            child: const _PopupAppTile(
              icon: Icons.settings,
              name: 'Manage apps',
              isSelected: false,
            ),
          ),
        ],
      );
    } else {
      // On mobile, show a bottom sheet
      showModalBottomSheet(
        context: context,
        backgroundColor: colors.bgBase,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => _AppPickerSheet(
          sidebarApps: sidebarApps,
          selectedApp: selectedApp,
          onSelect: (app) {
            ref.read(appContextProvider.notifier).select(app);
            Navigator.pop(context);
          },
          onManageApps: () {
            Navigator.pop(context);
            context.go('/apps/manage');
          },
        ),
      );
    }
  }
}

class _AppPickerSheet extends StatelessWidget {
  final SidebarApps sidebarApps;
  final AppModel? selectedApp;
  final ValueChanged<AppModel?> onSelect;
  final VoidCallback onManageApps;

  const _AppPickerSheet({
    required this.sidebarApps,
    required this.selectedApp,
    required this.onSelect,
    required this.onManageApps,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // All apps option
          _AppTile(
            icon: Icons.apps,
            name: 'All apps',
            isSelected: selectedApp == null,
            onTap: () => onSelect(null),
          ),

          Divider(color: colors.border, height: 1),

          // App list
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                if (sidebarApps.favorites.isNotEmpty) ...[
                  const _SectionHeader(title: 'Favorites'),
                  ...sidebarApps.favorites.map((app) => _AppTile(
                        iconUrl: app.iconUrl,
                        name: app.name,
                        isSelected: selectedApp?.id == app.id,
                        onTap: () => onSelect(app),
                      )),
                ],
                if (sidebarApps.iosList.isNotEmpty) ...[
                  const _SectionHeader(title: 'iPhone'),
                  ...sidebarApps.iosList.map((app) => _AppTile(
                        iconUrl: app.iconUrl,
                        name: app.name,
                        isSelected: selectedApp?.id == app.id,
                        onTap: () => onSelect(app),
                      )),
                ],
                if (sidebarApps.androidList.isNotEmpty) ...[
                  const _SectionHeader(title: 'Android'),
                  ...sidebarApps.androidList.map((app) => _AppTile(
                        iconUrl: app.iconUrl,
                        name: app.name,
                        isSelected: selectedApp?.id == app.id,
                        onTap: () => onSelect(app),
                      )),
                ],
              ],
            ),
          ),

          Divider(color: colors.border, height: 1),

          // Manage apps
          _AppTile(
            icon: Icons.settings,
            name: 'Manage apps',
            isSelected: false,
            onTap: onManageApps,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: colors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  final IconData? icon;
  final String? iconUrl;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppTile({
    this.icon,
    this.iconUrl,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      leading: iconUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                iconUrl!,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.apps, color: colors.textMuted),
              ),
            )
          : Icon(icon, color: colors.textMuted),
      title: Text(
        name,
        style: TextStyle(
          color: colors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: colors.accent) : null,
      onTap: onTap,
    );
  }
}

/// Compact app tile for popup menu (desktop)
class _PopupAppTile extends StatelessWidget {
  final IconData? icon;
  final String? iconUrl;
  final String name;
  final bool isSelected;

  const _PopupAppTile({
    this.icon,
    this.iconUrl,
    required this.name,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        if (iconUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              iconUrl!,
              width: 24,
              height: 24,
              errorBuilder: (_, _, _) => Icon(Icons.apps, size: 24, color: colors.textMuted),
            ),
          )
        else
          Icon(icon, size: 24, color: colors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isSelected)
          Icon(Icons.check, size: 18, color: colors.accent),
      ],
    );
  }
}
