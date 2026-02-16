import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/colors.dart';

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
  double _keyboardHeight = 310;

  @override
  void dispose() {
    _emojiScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double currentKeyboardHeight = MediaQuery.of(
      context,
    ).viewInsets.bottom;
    if (currentKeyboardHeight > 0) {
      _keyboardHeight = currentKeyboardHeight;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
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
            height: _keyboardHeight,
            child: CustomEmojiPicker(
              controller: widget.controller,
              scrollController: _emojiScrollController,
            ),
          ),
      ],
    );
  }
}

class CustomEmojiPicker extends StatefulWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  const CustomEmojiPicker({
    super.key,
    required this.controller,
    required this.scrollController,
  });

  @override
  State<CustomEmojiPicker> createState() => _CustomEmojiPickerState();
}

class _CustomEmojiPickerState extends State<CustomEmojiPicker>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xff131419),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: searchBarColor,
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              labelPadding: EdgeInsets.zero,
              padding: const EdgeInsets.all(3),
              tabs: const [
                Tab(text: "Emoji"),
                Tab(text: "GIFs"),
                Tab(text: "Stickers"),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _emojiTab(),
              const Center(
                child: Text("GIFs", style: TextStyle(color: Colors.white)),
              ),
              const Center(
                child: Text("Stickers", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emojiTab() {
    return EmojiPicker(
      scrollController: widget.scrollController,
      textEditingController: widget.controller,
      config: Config(
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
          columns: 7,
          emojiSizeMax: 28,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          buttonMode: ButtonMode.MATERIAL,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          loadingIndicator: const SizedBox.shrink(),
          replaceEmojiOnLimitExceed: false,
        ),
        categoryViewConfig: const CategoryViewConfig(
          backgroundColor: backgroundColor,
          indicatorColor: whiteColor,
          iconColorSelected: whiteColor,
          iconColor: Colors.grey,
          categoryIcons: CategoryIcons(),
        ),
        searchViewConfig: const SearchViewConfig(
          backgroundColor: Color(0xff131419),
          buttonIconColor: Colors.grey,
        ),
        bottomActionBarConfig: const BottomActionBarConfig(
          enabled: true,
          backgroundColor: backgroundColor,
          buttonIconColor: whiteColor,
          showSearchViewButton: true,
          showBackspaceButton: true,
        ),
        skinToneConfig: const SkinToneConfig(enabled: false),
      ),
    );
  }
}
