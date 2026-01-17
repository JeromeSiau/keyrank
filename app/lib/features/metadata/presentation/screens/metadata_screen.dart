import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_context_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import 'metadata_editor_screen.dart';

/// Metadata screen that uses the global app context.
/// - Global mode (no app selected): Shows prompt to select an app
/// - App mode (app selected): Shows metadata editor for that app
class MetadataScreen extends ConsumerWidget {
  const MetadataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApp = ref.watch(appContextProvider);

    if (selectedApp == null) {
      return const _GlobalMetadataView();
    }

    return MetadataEditorScreen(
      appId: selectedApp.id,
      appName: selectedApp.name,
    );
  }
}

/// Global view prompting user to select an app
class _GlobalMetadataView extends StatelessWidget {
  const _GlobalMetadataView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.metadata_editor),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note_outlined, size: 64, color: colors.textMuted),
            const SizedBox(height: 16),
            Text(
              context.l10n.metadata_selectAppFirst,
              style: TextStyle(fontSize: 18, color: colors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.metadata_selectAppHint,
              style: TextStyle(fontSize: 14, color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
