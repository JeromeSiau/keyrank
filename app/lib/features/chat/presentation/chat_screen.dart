import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../data/chat_repository.dart';
import '../domain/chat_models.dart';
import '../providers/chat_provider.dart';
import '../../../shared/widgets/safe_image.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh conversations when screen appears (title may have changed)
    Future.microtask(() => ref.invalidate(conversationsProvider));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final conversationsAsync = ref.watch(conversationsProvider);
    final quotaAsync = ref.watch(chatQuotaProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _buildToolbar(context, quotaAsync),

          // Content
          Expanded(
            child: conversationsAsync.when(
              loading: () => _buildLoadingState(context),
              error: (e, _) => _buildErrorState(context, e),
              data: (paginatedConversations) {
                if (paginatedConversations.conversations.isEmpty) {
                  return _buildEmptyState(context);
                }
                return _buildConversationsList(
                    context, paginatedConversations.conversations);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(
      BuildContext context, AsyncValue<ChatQuota> quotaAsync) {
    final colors = context.colors;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: colors.accent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            context.l10n.chat_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          // Quota indicator
          quotaAsync.maybeWhen(
            data: (quota) => _QuotaIndicator(quota: quota),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(width: 12),
          // New conversation button
          FilledButton.icon(
            onPressed: () => _createNewConversation(context),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.l10n.chat_newConversation),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
            onPressed: () => ref.invalidate(conversationsProvider),
            tooltip: context.l10n.common_refresh,
          ),
        ],
      ),
    );
  }

  Future<void> _createNewConversation(BuildContext context) async {
    final repository = ref.read(chatRepositoryProvider);
    final selectedApp = ref.read(appContextProvider);

    try {
      final conversation = await repository.createConversation(
        appId: selectedApp?.id,
      );
      ref.invalidate(conversationsProvider);
      if (context.mounted) {
        context.go('/chat/${conversation.id}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.chat_createFailed(e.toString()))),
        );
      }
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 16),
          Text(
            context.l10n.chat_loadingConversations,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.redMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 32,
              color: colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.common_error(error.toString()),
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => ref.invalidate(conversationsProvider),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(context.l10n.common_retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.chat_noConversations,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.chat_noConversationsDesc,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _createNewConversation(context),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.l10n.chat_startConversation),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(
      BuildContext context, List<ChatConversation> conversations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _ConversationCard(
          conversation: conversation,
          onTap: () => context.go('/chat/${conversation.id}'),
          onDelete: () => _deleteConversation(context, conversation),
        );
      },
    );
  }

  Future<void> _deleteConversation(
      BuildContext context, ChatConversation conversation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.chat_deleteConversation),
        content: Text(context.l10n.chat_deleteConversationConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.red,
            ),
            child: Text(context.l10n.common_delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = ref.read(chatRepositoryProvider);
      try {
        await repository.deleteConversation(conversation.id);
        ref.invalidate(conversationsProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: $e')),
          );
        }
      }
    }
  }
}

class _QuotaIndicator extends StatelessWidget {
  final ChatQuota quota;

  const _QuotaIndicator({required this.quota});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (quota.isUnlimited) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colors.greenMuted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.all_inclusive, size: 14, color: colors.green),
            const SizedBox(width: 4),
            Text(
              'Unlimited',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.green,
              ),
            ),
          ],
        ),
      );
    }

    final isLow = quota.remaining <= 5;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLow ? colors.redMuted : colors.bgActive,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${quota.remaining}/${quota.limit} left',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isLow ? colors.red : colors.textSecondary,
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ConversationCard({
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.bgActive,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // App icon if exists
                if (conversation.app != null) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.glassBorder,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: conversation.app!.iconUrl != null
                        ? SafeImage(
                            imageUrl: conversation.app!.iconUrl!,
                            fit: BoxFit.cover,
                            errorWidget: Icon(
                              Icons.apps,
                              color: colors.textMuted,
                              size: 20,
                            ),
                          )
                        : Icon(
                            Icons.apps,
                            color: colors.textMuted,
                            size: 20,
                          ),
                  ),
                  const SizedBox(width: 12),
                ] else ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.accent.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: colors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // Title and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.displayTitle,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (conversation.app != null) ...[
                            Text(
                              conversation.app!.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textMuted,
                              ),
                            ),
                            Container(
                              width: 3,
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: colors.textMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                          Text(
                            _formatDate(conversation.updatedAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: colors.textMuted,
                    size: 20,
                  ),
                  onPressed: onDelete,
                ),

                // Arrow
                Icon(
                  Icons.chevron_right,
                  color: colors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
