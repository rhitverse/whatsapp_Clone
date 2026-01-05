import 'package:flutter/material.dart';

class ChatFilterItems extends StatefulWidget {
  final bool isWeb;
  const ChatFilterItems({super.key, required this.isWeb});

  @override
  State<ChatFilterItems> createState() => _ChatFilterItemsState();
}

class _ChatFilterItemsState extends State<ChatFilterItems> {
  int selectedIndex = 0;

  final List<String> filters = [
    "All",
    "Unread",
    "Favourites",
    "Groups",
    "Communities",
  ];
  @override
  Widget build(BuildContext context) {
    final double chipHeight = widget.isWeb ? 32 : 32;
    final double horizontalPadding = widget.isWeb ? 14 : 14;
    final double verticalPadding = widget.isWeb ? 5 : 6;
    final double fontsize = widget.isWeb ? 14 : 13;
    return Transform.translate(
      offset: Offset(0, widget.isWeb ? 11 : -4),
      child: SizedBox(
        height: chipHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: filters.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1F3D2B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),

                  border: Border.all(
                    color: isSelected
                        ? const Color.fromARGB(255, 1, 73, 33)
                        : const Color(0xff3a3f41),
                    width: 0.9,
                  ),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected
                        ? Color.fromARGB(255, 129, 230, 174)
                        : Colors.grey,
                    fontSize: fontsize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
