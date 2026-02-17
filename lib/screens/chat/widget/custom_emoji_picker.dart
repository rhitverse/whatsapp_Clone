import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

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
  void didUpdateWidget(covariant CustomEmojiPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _tabController.index = 0;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          height: MediaQuery.of(context).size.height * 0.04,
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
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
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
      textEditingController: widget.controller,
      onEmojiSelected: (category, emoji) {
        final text = widget.controller.text;
        final selection = widget.controller.selection;
        final newText = selection.isValid
            ? text.replaceRange(selection.start, selection.end, emoji.emoji)
            : text + emoji.emoji;

        widget.controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: selection.isValid
                ? selection.start + emoji.emoji.length
                : newText.length,
          ),
        );
      },
      config: Config(
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
          columns: 8,
          emojiSizeMax: 28,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          buttonMode: ButtonMode.MATERIAL,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 15, color: Colors.grey),
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
