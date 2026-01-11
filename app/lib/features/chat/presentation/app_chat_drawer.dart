import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../apps/domain/app_model.dart';
import '../data/chat_repository.dart';
import '../domain/chat_models.dart';
import 'widgets/message_bubble.dart';

/// A slide-in drawer for chatting about a specific app.
class AppChatDrawer extends ConsumerStatefulWidget {
  final AppModel app;
  final VoidCallback onClose;

  const AppChatDrawer({
    super.key,
    required this.app,
    required this.onClose,
  });

  @override
  ConsumerState<AppChatDrawer> createState() => _AppChatDrawerState();
}

class _AppChatDrawerState extends ConsumerState<AppChatDrawer> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  bool _isLoading = false;
  bool _isSending = false;
  ChatConversation? _conversation;
  List<ChatMessage> _messages = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(chatRepositoryProvider);
      final conversation = await repository.getAppConversation(widget.app.id);
      if (mounted) {
        setState(() {
          _conversation = conversation;
          _messages = conversation.messages;
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty || _isSending || _conversation == null) return;

    final trimmedMessage = message.trim();
    _controller.clear();

    // Add optimistic user message
    final userMessage = ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch,
      role: 'user',
      content: trimmedMessage,
      createdAt: DateTime.now(),
    );

    setState(() {
      _isSending = true;
      _messages = [..._messages, userMessage];
      _error = null;
    });
    _scrollToBottom();

    try {
      final repository = ref.read(chatRepositoryProvider);
      final assistantMessage = await repository.sendMessage(
        _conversation!.id,
        trimmedMessage,
      );

      if (mounted) {
        // Replace optimistic message and add assistant response
        final updatedMessages = _messages
            .where((m) => m.id != userMessage.id)
            .toList();

        setState(() {
          _isSending = false;
          _messages = [
            ...updatedMessages,
            ChatMessage(
              id: assistantMessage.id - 1,
              role: 'user',
              content: trimmedMessage,
              createdAt: assistantMessage.createdAt.subtract(const Duration(seconds: 1)),
            ),
            assistantMessage,
          ];
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        // Remove optimistic message on error
        setState(() {
          _isSending = false;
          _messages = _messages.where((m) => m.id != userMessage.id).toList();
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border(left: BorderSide(color: colors.glassBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 20,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(colors),
          // Messages
          Expanded(
            child: _isLoading
                ? _buildLoadingState(colors)
                : _error != null && _messages.isEmpty
                    ? _buildErrorState(colors)
                    : _messages.isEmpty
                        ? _buildEmptyState(colors)
                        : _buildMessagesArea(colors),
          ),
          // Input
          _buildInput(colors),
        ],
      ),
    );
  }

  Widget _buildHeader(AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.accent, colors.purple],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat about ${widget.app.name}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Ask about reviews, rankings, keywords...',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colors.textMuted),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(AppColorsExtension colors) {
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

  Widget _buildErrorState(AppColorsExtension colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              _error ?? 'An error occurred',
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loadConversation,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(context.l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorsExtension colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAssistantMessage(
            colors,
            'Hello! I can help you analyze ${widget.app.name}. '
            'Ask me about reviews, rankings, keywords, or any insights about this app.',
          ),
          const SizedBox(height: 16),
          _buildSuggestedQuestions(colors),
        ],
      ),
    );
  }

  Widget _buildMessagesArea(AppColorsExtension colors) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isSending && index == _messages.length) {
          return const TypingIndicator();
        }
        final message = _messages[index];
        return MessageBubble(
          message: message,
          isLast: index == _messages.length - 1 && !_isSending,
        );
      },
    );
  }

  Widget _buildAssistantMessage(AppColorsExtension colors, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colors.accent.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.auto_awesome, size: 16, color: colors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.bgHover,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: colors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedQuestions(AppColorsExtension colors) {
    final suggestions = [
      'What are the main complaints in reviews?',
      'How are my keywords performing?',
      'What countries have the best ratings?',
      'Summarize recent negative reviews',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions.map((q) {
        return InkWell(
          onTap: () => _sendMessage(q),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: colors.glassBorder),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              q,
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInput(AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !_isSending,
              style: TextStyle(color: colors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: context.l10n.chat_typeMessage,
                hintStyle: TextStyle(color: colors.textMuted),
                filled: true,
                fillColor: colors.bgHover,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          _isSending
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.accent,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () => _sendMessage(_controller.text),
                  icon: Icon(Icons.send_rounded, color: colors.accent),
                ),
        ],
      ),
    );
  }
}
