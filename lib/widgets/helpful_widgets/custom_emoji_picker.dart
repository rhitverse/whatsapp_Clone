import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class CustomEmojiPicker extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onClose;

  const CustomEmojiPicker({super.key, required this.controller, this.onClose});

  @override
  State<CustomEmojiPicker> createState() => _CustomEmojiPickerState();
}

class _CustomEmojiPickerState extends State<CustomEmojiPicker>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1), // Start from bottom (off-screen)
          end: Offset.zero, // End at normal position
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return const SizedBox();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag indicator
            GestureDetector(
              onTap: () async {
                await _animationController.reverse();
                if (widget.onClose != null) {
                  widget.onClose!();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Tabs - Emoji, GIFs, Stickers
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF383838),
                  borderRadius: BorderRadius.circular(25),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[500],
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Emoji'),
                  Tab(text: 'GIFs'),
                  Tab(text: 'Stickers'),
                ],
              ),
            ),

            // Search bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600], size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'Find the perfect emoji',
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content area
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Emoji Tab
                  _buildEmojiContent(),

                  // GIFs Tab
                  Center(
                    child: Text(
                      'GIFs',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                  ),

                  // Stickers Tab
                  Center(
                    child: Text(
                      'Stickers',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiContent() {
    return EmojiPicker(
      textEditingController: widget.controller,
      config: Config(
        height: 256,
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
          emojiSizeMax: 32,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: const EdgeInsets.symmetric(horizontal: 8),
          columns: 8,
          recentsLimit: 28,
          replaceEmojiOnLimitExceed: false,
          backgroundColor: const Color(0xFF1E1E1E),
          noRecents: Text(
            'No recent emojis',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          loadingIndicator: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A884)),
            ),
          ),
          buttonMode: ButtonMode.MATERIAL,
        ),
        skinToneConfig: const SkinToneConfig(
          enabled: true,
          dialogBackgroundColor: Color(0xFF2A2A2A),
          indicatorColor: Color(0xFF00A884),
        ),
        categoryViewConfig: CategoryViewConfig(
          iconColorSelected: const Color(0xFF00A884),
          iconColor: Colors.grey[600]!,
          indicatorColor: const Color(0xFF00A884),
          backgroundColor: const Color(0xFF1E1E1E),
          dividerColor: Colors.grey[850]!,
          recentTabBehavior: RecentTabBehavior.RECENT,
          tabIndicatorAnimDuration: const Duration(milliseconds: 300),
        ),
        bottomActionBarConfig: BottomActionBarConfig(
          enabled: true,
          showBackspaceButton: true,
          showSearchViewButton: false,
          backgroundColor: const Color(0xFF1E1E1E),
          buttonColor: Colors.grey[800]!,
          buttonIconColor: Colors.grey[500]!,
        ),
        searchViewConfig: SearchViewConfig(
          backgroundColor: const Color(0xFF1E1E1E),
          buttonIconColor: const Color(0xFF00A884),
          hintText: 'Search emoji...',
          hintTextStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
          inputTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      onEmojiSelected: (category, emoji) {
        // Emoji automatically added to controller
      },
    );
  }
}

// Backdrop widget
class EmojiPickerBackdrop extends StatelessWidget {
  final VoidCallback onTap;

  const EmojiPickerBackdrop({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(color: Colors.black.withValues(alpha: 0.5)),
    );
  }
}
