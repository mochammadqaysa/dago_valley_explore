import 'package:flutter/material.dart';

class HoverImageWidget extends StatefulWidget {
  final String imageUrl;
  final bool isDarkMode;
  final VoidCallback onFullscreen;

  const HoverImageWidget({
    Key? key,
    required this.imageUrl,
    required this.isDarkMode,
    required this.onFullscreen,
  }) : super(key: key);

  @override
  State<HoverImageWidget> createState() => _HoverImageWidgetState();
}

class _HoverImageWidgetState extends State<HoverImageWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main Image
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.isDarkMode ? Colors.white : Colors.transparent,
            ),
            child: Image.asset(
              widget.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: Colors.white.withOpacity(0.5),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gambar tidak ditemukan',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Fullscreen Button (Appears on Hover)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isHovered ? 20 : -60,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onFullscreen,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          // Hover Overlay (Optional)
          if (_isHovered)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
