import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../domain/chat_models.dart';
import '../providers/chat_provider.dart';
import 'widgets/message_bubble.dart';
import 'widgets/suggested_questions.dart';
import '../../../shared/widgets/safe_image.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  final int conversationId;

  const ChatConversationScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatConversationScreen> createState() =>
      _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends ConsumerState<ChatConversationScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load conversation on init
    Future.microtask(() {
      ref
          .read(chatNotifierProvider(widget.conversationId).notifier)
          .loadConversation();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    _scrollToBottom();

    await ref
        .read(chatNotifierProvider(widget.conversationId).notifier)
        .sendMessage(message);

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final chatState = ref.watch(chatNotifierProvider(widget.conversationId));

    // Scroll to bottom when messages change
    ref.listen(chatNotifierProvider(widget.conversationId), (prev, next) {
      if (prev?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context, chatState),

          // Messages
          Expanded(
            child: chatState.isLoading
                ? _buildLoadingState(context)
                : chatState.error != null
                    ? _buildErrorState(context, chatState.error!)
                    : chatState.messages.isEmpty
                        ? _buildEmptyState(context, chatState.conversation)
                        : _buildMessagesList(context, chatState),
          ),

          // Input
          _buildInputArea(context, chatState),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ChatState chatState) {
    final colors = context.colors;
    final conversation = chatState.conversation;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            onPressed: () => context.go('/chat'),
          ),
          const SizedBox(width: 8),

          // App icon if exists
          if (conversation?.app != null) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.glassBorder,
                borderRadius: BorderRadius.circular(6),
              ),
              clipBehavior: Clip.antiAlias,
              child: conversation!.app!.iconUrl != null
                  ? SafeImage(
                      imageUrl: conversation.app!.iconUrl!,
                      fit: BoxFit.cover,
                      errorWidget: Icon(
                        Icons.apps,
                        color: colors.textMuted,
                        size: 16,
                      ),
                    )
                  : Icon(
                      Icons.apps,
                      color: colors.textMuted,
                      size: 16,
                    ),
            ),
            const SizedBox(width: 12),
          ],

          // Title
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation?.displayTitle ?? context.l10n.chat_newConversation,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (conversation?.app != null)
                  Text(
                    conversation!.app!.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
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
            context.l10n.chat_loadingMessages,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
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
            error,
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => ref
                .read(chatNotifierProvider(widget.conversationId).notifier)
                .loadConversation(),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(context.l10n.common_retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, ChatConversation? conversation) {
    final colors = context.colors;
    final appId = conversation?.app?.id;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 40,
              color: colors.accent,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.chat_askAnything,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.chat_askAnythingDesc,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          if (appId != null) ...[
            const SizedBox(height: 24),
            SuggestedQuestionsWidget(
              appId: appId,
              onQuestionSelected: (question) {
                _messageController.text = question;
                _focusNode.requestFocus();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, ChatState chatState) {
    final messages = chatState.messages;
    final notifier = ref.read(chatNotifierProvider(widget.conversationId).notifier);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (chatState.isSending ? 1 : 0),
      itemBuilder: (context, index) {
        // Show typing indicator at the end when sending
        if (chatState.isSending && index == messages.length) {
          return const TypingIndicator();
        }

        final message = messages[index];
        return MessageBubble(
          message: message,
          isLast: index == messages.length - 1 && !chatState.isSending,
          executingActionIds: chatState.executingActionIds,
          onConfirmAction: (action) => notifier.executeAction(action),
          onCancelAction: (action) => notifier.cancelAction(action),
        );
      },
    );
  }

  Widget _buildInputArea(BuildContext context, ChatState chatState) {
    final colors = context.colors;
    final isSending = chatState.isSending;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.bgActive,
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                border: Border.all(color: colors.glassBorder),
              ),
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter) {
                    final isModifierPressed =
                        HardwareKeyboard.instance.isControlPressed ||
                            HardwareKeyboard.instance.isMetaPressed;
                    if (isModifierPressed) {
                      // Ctrl/Cmd+Enter: insert new line
                      final text = _messageController.text;
                      final selection = _messageController.selection;
                      final newText = text.replaceRange(
                        selection.start,
                        selection.end,
                        '\n',
                      );
                      _messageController.value = TextEditingValue(
                        text: newText,
                        selection: TextSelection.collapsed(
                          offset: selection.start + 1,
                        ),
                      );
                    } else {
                      // Enter alone: send message
                      _sendMessage();
                    }
                  }
                },
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  enabled: !isSending,
                  maxLines: 4,
                  minLines: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: context.l10n.chat_typeMessage,
                    hintStyle: TextStyle(color: colors.textMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: colors.textPrimary,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: isSending
                ? Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.accent.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.accent,
                        ),
                      ),
                    ),
                  )
                : Material(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
