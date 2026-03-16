import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp_clone/models/diary_model.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryModel entry;

  const DiaryDetailScreen({super.key, required this.entry});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const _weatherIcons = [
    'assets/svg/sunny.svg',
    'assets/svg/cloud.svg',
    'assets/svg/wind.svg',
    'assets/svg/rain.svg',
    'assets/svg/snow.svg',
    'assets/svg/fog.svg',
  ];
  static const _moodIcons = [
    'assets/svg/smile.svg',
    'assets/svg/unsmile.svg',
    'assets/svg/bad.svg',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<String> get _imageUrls {
    final e = widget.entry;
    if (e.mediaUrls.isEmpty) return [];
    final images = <String>[];
    for (int i = 0; i < e.mediaUrls.length; i++) {
      final type = i < e.mediaTypes.length ? e.mediaTypes[i] : '';
      if (type.startsWith('image')) {
        images.add(e.mediaUrls[i]);
      }
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final imageUrls = _imageUrls;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.28),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Blue Gradient Header ─────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF42B8EE), Color(0xFF1E96C8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Close ×
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),

                          // Date + time + icons (centred)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Month
                              Text(
                                e.month.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Big day number
                              Text(
                                e.day,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 64,
                                  fontWeight: FontWeight.w300,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Weekday · time · weather icon · mood icon
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${e.weekday}   ${e.time}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.93),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    _weatherIcons[e.weatherIndex.clamp(
                                      0,
                                      _weatherIcons.length - 1,
                                    )],
                                    width: 17,
                                    height: 17,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  SvgPicture.asset(
                                    _moodIcons[e.moodIndex.clamp(
                                      0,
                                      _moodIcons.length - 1,
                                    )],
                                    width: 17,
                                    height: 17,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Scrollable Body ──────────────────────────────────
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Entry text
                            Text(
                              e.text,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF2C3E50),
                                height: 1.7,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            if (imageUrls.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              ...imageUrls.map(
                                (url) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      url,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (_, child, progress) {
                                        if (progress == null) return child;
                                        return Container(
                                          height: 160,
                                          color: Colors.grey.shade100,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
