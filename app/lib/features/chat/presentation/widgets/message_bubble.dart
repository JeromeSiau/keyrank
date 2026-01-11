import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/chat_models.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLast;

  const MessageBubble({
    super.key,
    required this.message,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(context, isUser),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? colors.accent : colors.bgActive,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: colors.glassBorder),
                  ),
                  child: SelectableText(
                    message.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: isUser ? Colors.white : colors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Data sources used
                    if (!isUser && message.dataSourcesUsed != null) ...[
                      ...message.dataSourcesUsed!.map((source) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _DataSourceChip(source: source),
                          )),
                    ],
                    // Timestamp
                    Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                    ),
                    // Copy button for assistant messages
                    if (!isUser) ...[
                      const SizedBox(width: 8),
                      _CopyButton(content: message.content),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(context, isUser),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isUser) {
    final colors = context.colors;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isUser ? colors.accent.withAlpha(20) : colors.bgActive,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Icon(
        isUser ? Icons.person_outline : Icons.auto_awesome,
        size: 18,
        color: isUser ? colors.accent : colors.accent,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _DataSourceChip extends StatelessWidget {
  final String source;

  const _DataSourceChip({required this.source});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    IconData icon;
    Color chipColor;

    switch (source) {
      case 'reviews':
        icon = Icons.rate_review_outlined;
        chipColor = colors.yellow;
        break;
      case 'rankings':
        icon = Icons.trending_up;
        chipColor = colors.green;
        break;
      case 'analytics':
        icon = Icons.analytics_outlined;
        chipColor = colors.accent;
        break;
      case 'competitors':
        icon = Icons.groups_outlined;
        chipColor = colors.purple;
        break;
      default:
        icon = Icons.info_outline;
        chipColor = colors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: chipColor),
          const SizedBox(width: 4),
          Text(
            source,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String content;

  const _CopyButton({required this.content});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.content));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: _copy,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          _copied ? Icons.check : Icons.copy_outlined,
          size: 14,
          color: _copied ? colors.green : colors.textMuted,
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.glassBorder),
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 18,
              color: colors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: colors.glassBorder),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final value =
                        ((_controller.value + delay) % 1.0 * 2 - 1).abs();
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: colors.textMuted.withAlpha((150 + 105 * value).toInt()),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
