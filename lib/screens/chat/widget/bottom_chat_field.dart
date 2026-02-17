import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/screens/chat/widget/custom_emoji_picker.dart';

class BottomChatField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showEmoji;
  final VoidCallback onEmojiTap;
  final VoidCallback onSend;

  const BottomChatField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.showEmoji,
    required this.onEmojiTap,
    required this.onSend,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final ScrollController _emojiScrollController = ScrollController();
  double _emojiHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    const appBarHeight = kToolbarHeight;
    const chatFieldHeight = 66.0;

    final available =
        screenHeight -
        padding.top -
        padding.bottom -
        appBarHeight -
        chatFieldHeight;

    return available.clamp(200.0, 450.0);
  }

  @override
  void dispose() {
    _emojiScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              top: BorderSide(color: Colors.grey[900]!, width: 0.5),
            ),
          ),
          child: SafeArea(
            bottom: !widget.showEmoji,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[900],
                  radius: 20,
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[800]!, width: 1),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      readOnly: widget.showEmoji,
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      onSubmitted: (_) => widget.onSend(),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            widget.focusNode.unfocus();
                            widget.onEmojiTap();
                          },
                          child: Icon(
                            widget.showEmoji
                                ? Icons.keyboard_alt_outlined
                                : Icons.emoji_emotions_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        contentPadding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 16,
                          right: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.controller,
                  builder: (context, value, child) {
                    final hasText = value.text.trim().isNotEmpty;
                    return GestureDetector(
                      onTap: hasText ? widget.onSend : null,
                      child: SvgPicture.asset(
                        hasText
                            ? "assets/svg/message.svg"
                            : "assets/svg/mic.svg",
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(
                          whiteColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (widget.showEmoji)
          SizedBox(
            height: _emojiHeight(context),
            child: CustomEmojiPicker(
              controller: widget.controller,
              scrollController: _emojiScrollController,
            ),
          ),
      ],
    );
  }
}
