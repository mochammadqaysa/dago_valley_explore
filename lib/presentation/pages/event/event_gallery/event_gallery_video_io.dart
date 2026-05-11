import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player_win/video_player_win.dart';

WinVideoPlayerController? _controller;
bool _isMuted = false;

Future<bool> initializeVideoPlayer(dynamic file) async {
  if (file is! File) return false;

  try {
    _controller = WinVideoPlayerController.file(file);
    await _controller!.initialize();
    await _controller!.play();
    return true;
  } catch (e) {
    print('Error initializing video: $e');
    return false;
  }
}

void disposeVideoPlayer() {
  _controller?.dispose();
  _controller = null;
}

Widget buildFullVideoPlayerWidget({required VoidCallback onBack}) {
  if (_controller == null || !_controller!.value.isInitialized) {
    return const SizedBox.shrink();
  }

  return StatefulBuilder(
    builder: (context, setState) {
      void toggleMute() {
        setState(() {
          _isMuted = !_isMuted;
          _controller!.setVolume(_isMuted ? 0.0 : 1.0);
        });
      }

      void togglePlayPause() {
        setState(() {
          _controller!.value.isPlaying
              ? _controller!.pause()
              : _controller!.play();
        });
      }

      String formatDuration(Duration duration) {
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        final minutes = twoDigits(duration.inMinutes.remainder(60));
        final seconds = twoDigits(duration.inSeconds.remainder(60));
        return '$minutes:$seconds';
      }

      return Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: togglePlayPause,
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: WinVideoPlayer(_controller!),
              ),
            ),
          ),

          // Video Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress slider
                  ValueListenableBuilder(
                    valueListenable: _controller!,
                    builder: (context, value, child) {
                      final position = value.position.inMilliseconds.toDouble();
                      final duration = value.duration.inMilliseconds.toDouble();

                      return Slider(
                        value: duration > 0 ? position : 0,
                        max: duration > 0 ? duration : 1,
                        onChanged: (newValue) {
                          _controller!.seekTo(
                            Duration(milliseconds: newValue.toInt()),
                          );
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white38,
                      );
                    },
                  ),

                  // Control buttons
                  Row(
                    children: [
                      // Play/Pause button
                      IconButton(
                        icon: ValueListenableBuilder(
                          valueListenable: _controller!,
                          builder: (context, value, child) {
                            return Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            );
                          },
                        ),
                        onPressed: togglePlayPause,
                      ),

                      const SizedBox(width: 8),

                      // Mute/Unmute button
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: toggleMute,
                      ),

                      const Spacer(),

                      // Time display
                      ValueListenableBuilder(
                        valueListenable: _controller!,
                        builder: (context, value, child) {
                          final position = value.position;
                          final duration = value.duration;
                          return Text(
                            '${formatDuration(position)} / ${formatDuration(duration)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Play/Pause overlay (center)
          Center(
            child: ValueListenableBuilder(
              valueListenable: _controller!,
              builder: (context, value, child) {
                if (value.isPlaying) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: togglePlayPause,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

Widget buildVideoThumbnailWidget(dynamic videoFile) {
  if (videoFile is! File) {
    return Container(
      color: Colors.grey[900],
      child: const Icon(
        Icons.video_library_rounded,
        color: Colors.white54,
        size: 48,
      ),
    );
  }
  return _VideoThumbnailWidget(videoFile: videoFile);
}

class _VideoThumbnailWidget extends StatefulWidget {
  final File videoFile;

  const _VideoThumbnailWidget({required this.videoFile});

  @override
  State<_VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<_VideoThumbnailWidget> {
  WinVideoPlayerController? _thumbnailController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    try {
      _thumbnailController = WinVideoPlayerController.file(widget.videoFile);
      await _thumbnailController!.initialize();
      await _thumbnailController!.seekTo(const Duration(seconds: 1));
      await _thumbnailController!.pause();
      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (e) {
      debugPrint('Error initializing video thumbnail: $e');
    }
  }

  @override
  void dispose() {
    _thumbnailController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _thumbnailController == null) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _thumbnailController!.value.size.width,
        height: _thumbnailController!.value.size.height,
        child: WinVideoPlayer(_thumbnailController!),
      ),
    );
  }
}
