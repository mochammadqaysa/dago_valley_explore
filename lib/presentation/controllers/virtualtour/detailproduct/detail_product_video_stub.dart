/// Stub for web — video player operations are not supported.
import 'package:flutter/material.dart';

Future<dynamic> copyAssetToTemp(String assetPath, List<int> bytes) async => null;

Future<dynamic> createAndInitializeController(
  dynamic file, {
  VoidCallback? onCompleted,
}) async => null;

bool isPlaying(dynamic controller) => false;

void play(dynamic controller) {}

void pause(dynamic controller) {}

void seekTo(dynamic controller, Duration position) {}

void addListener(dynamic controller, VoidCallback listener) {}

void dispose(dynamic controller) {}

Future<void> deleteTempFile(dynamic file) async {}

/// Build a video player widget - on web, shows a placeholder
Widget buildVideoPlayer(dynamic controller) {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.videocam_off, size: 48, color: Colors.white54),
        SizedBox(height: 8),
        Text(
          'Video playback tidak tersedia di browser',
          style: TextStyle(color: Colors.white54),
        ),
      ],
    ),
  );
}
