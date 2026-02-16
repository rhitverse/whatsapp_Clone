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
  double _keyboardHeight = 300;

  @override
  void dispose() {
    _emojiScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight > 0) {
      _keyboardHeight = keyboardHeight;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border(
              top: BorderSide(color: Colors.grey[900]!, width: 0.5),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
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
                          onTap: widget.onEmojiTap,
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

                const SizedBox(width: 8),
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xff131419),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: whiteColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  child: const Icon(Icons.close, color: Colors.grey, size: 20),
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xff131419),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: searchBarColor,
              borderRadius: BorderRadius.circular(20),
            ),
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Emoji"),
              Tab(text: "GIFs"),
              Tab(text: "Stickers"),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
    if (_searchQuery.isNotEmpty) {
      return EmojiPicker(
        scrollController: widget.scrollController,
        textEditingController: widget.controller,
        config: Config(
          checkPlatformCompatibility: false,
          emojiViewConfig: const EmojiViewConfig(
            columns: 7,
            emojiSizeMax: 28,
            backgroundColor: backgroundColor,
          ),
          categoryViewConfig: const CategoryViewConfig(
            backgroundColor: backgroundColor,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: backgroundColor,
            buttonIconColor: Colors.white,
            hintText: _searchQuery,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            enabled: true,
            backgroundColor: backgroundColor,
            showSearchViewButton: false,
          ),
          skinToneConfig: const SkinToneConfig(enabled: false),
        ),
      );
    }
    return EmojiPicker(
      scrollController: widget.scrollController,
      textEditingController: widget.controller,
      config: const Config(
        checkPlatformCompatibility: false,
        emojiViewConfig: EmojiViewConfig(
          columns: 7,
          emojiSizeMax: 28,
          backgroundColor: backgroundColor,
        ),
        categoryViewConfig: CategoryViewConfig(
          backgroundColor: backgroundColor,
        ),
        bottomActionBarConfig: BottomActionBarConfig(enabled: false),
        skinToneConfig: SkinToneConfig(enabled: false),
      ),
    );
  }
}
