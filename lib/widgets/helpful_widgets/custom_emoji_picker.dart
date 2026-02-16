import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Padding(padding: const EdgeInsets.only(top: 8.0)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: const Color(0xFF404040),
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
        height: 400,
        emojiViewConfig: EmojiViewConfig(
          columns: 7,
          emojiSizeMax: 28,
          backgroundColor: const Color(0xFF1E1E1E),
        ),
        categoryViewConfig: const CategoryViewConfig(
          backgroundColor: Color(0xFF1E1E1E),
        ),
      ),
    );
  }
}
