import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/colors.dart';

class CameraUi extends StatefulWidget {
  const CameraUi({super.key});

  @override
  State<CameraUi> createState() => _CameraUiState();
}

class _CameraUiState extends State<CameraUi>
    with SingleTickerProviderStateMixin {
  bool _gridVisible = false;
  bool _isFrontCamera = false;
  FlashMode _flashMode = FlashMode.off;

  late AnimationController _shutterController;
  late Animation<double> _shutterAnimation;

  CameraController? _camController;
  List<CameraDescription> _cameras = [];
  bool _camReady = false;
  bool _isTakingPhoto = false;
  bool _isSwitching = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _shutterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _shutterAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _shutterController, curve: Curves.easeInOut),
    );
    _initCamera(front: false);
  }

  Future<void> _initCamera({required bool front}) async {
    if (!mounted) return;
    setState(() {
      _camReady = false;
    });

    final oldController = _camController;
    _camController = null;
    await oldController?.dispose();

    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    if (_cameras.isEmpty) return;

    final desc = _cameras.firstWhere(
      (c) =>
          c.lensDirection ==
          (front ? CameraLensDirection.front : CameraLensDirection.back),
      orElse: () => _cameras.first,
    );

    final controller = CameraController(
      desc,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      if (!front) {
        await controller.setFlashMode(_flashMode);
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
      return;
    }

    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() {
      _camController = controller;
      _isFrontCamera = front;
      _camReady = true;
    });
  }

  Future<void> _toggleFlash() async {
    if (!_camReady || _isFrontCamera) return;
    final next = _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    try {
      await _camController?.setFlashMode(next);
      setState(() => _flashMode = next);
    } catch (e) {
      debugPrint('Flash error: $e');
    }
  }

  Future<void> _flipCamera() async {
    setState(() => _isSwitching);
    _isFrontCamera = !_isFrontCamera;
    await _initCamera(front: _isFrontCamera);
  }

  Future<void> _onShutterTap() async {
    if (_isTakingPhoto || !_camReady || _camController == null) return;

    HapticFeedback.mediumImpact();
    setState(() => _isTakingPhoto = true);

    await _shutterController.forward();
    await _shutterController.reverse();

    try {
      final XFile file = await _camController!.takePicture();
      if (mounted) Navigator.of(context).pop(file.path);
    } catch (e) {
      debugPrint('Capture error: $e');
    } finally {
      if (mounted) setState(() => _isTakingPhoto = false);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _camController?.dispose();
    _shutterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildCameraPreview(),

          if (_gridVisible) _buildGridOverlay(),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),

          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(child: _buildRightIcons()),
          ),

          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_camReady || _camController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white54, strokeWidth: 2),
      );
    }

    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height:
                MediaQuery.of(context).size.width *
                _camController!.value.aspectRatio,
            child: CameraPreview(_camController!),
          ),
        ),
      ),
    );
  }

  Widget _buildGridOverlay() => CustomPaint(painter: _GridPainter());

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: whiteColor, size: 20),
            ),
          ),

          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildRightIcons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconButton(
          icon: _flashMode == FlashMode.torch
              ? Icons.flash_on
              : Icons.flash_off,
          onTap: _toggleFlash,
          active: _flashMode == FlashMode.torch,
        ),
        const SizedBox(height: 20),
        _iconButton(
          icon: Icons.grid_on,
          onTap: () => setState(() => _gridVisible = !_gridVisible),
          active: _gridVisible,
        ),
        const SizedBox(height: 20),
        _iconButton(icon: Icons.flip_camera_ios_outlined, onTap: _flipCamera),
        const SizedBox(height: 20),
        _iconButton(icon: Icons.image_outlined, onTap: () {}),
        const SizedBox(height: 20),
        _iconButton(icon: Icons.gif_box_outlined, onTap: () {}),
      ],
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: active ? whiteColor.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: active ? whiteColor : whiteColor.withOpacity(0.85),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Center(
      child: GestureDetector(
        onTap: _onShutterTap,
        child: ScaleTransition(
          scale: _shutterAnimation,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: whiteColor, width: 3),
              color: whiteColor.withOpacity(0.15),
            ),
            child: Center(
              child: _isTakingPhoto
                  ? const CircularProgressIndicator(
                      color: whiteColor,
                      strokeWidth: 2,
                    )
                  : Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = whiteColor.withOpacity(0.25)
      ..strokeWidth = 0.8;

    for (int i = 1; i < 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (int i = 1; i < 3; i++) {
      final x = size.width * i / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
