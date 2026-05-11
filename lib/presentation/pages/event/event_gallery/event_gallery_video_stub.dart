import 'package:flutter/material.dart';

Future<bool> initializeVideoPlayer(dynamic file) async {
  return false;
}

void disposeVideoPlayer() {}

Widget buildFullVideoPlayerWidget({required VoidCallback onBack}) {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.videocam_off, size: 64, color: Colors.white54),
        SizedBox(height: 16),
        Text(
          'Video playback tidak tersedia di browser',
          style: TextStyle(color: Colors.white54),
        ),
      ],
    ),
  );
}

Widget buildVideoThumbnailWidget(dynamic videoFile) {
  return Container(
    color: Colors.grey[900],
    child: const Icon(
      Icons.video_library_rounded,
      color: Colors.white54,
      size: 48,
    ),
  );
}
