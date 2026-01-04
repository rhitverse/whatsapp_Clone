import 'package:flutter/material.dart';

class ChatFilterItems extends StatefulWidget {
  const ChatFilterItems({super.key});

  @override
  State<ChatFilterItems> createState() => _ChatFilterItemsState();
}

class _ChatFilterItemsState extends State<ChatFilterItems> {
  int selectedIndex = 0;

  final List<String> filters = [
    "All",
    "Unread",
    "Favorites",
    "Groups",
    "Communities",
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1F3D2B)
                    : const Color(0xff23282c),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  color: isSelected
                      ? Color.fromARGB(255, 129, 230, 174)
                      : Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
