import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player_win/video_player_win.dart';

Future<File?> copyAssetToTemp(String assetPath, List<int> bytes) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath =
        '${tempDir.path}${Platform.pathSeparator}video_${timestamp}_$fileName';

    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    if (!await file.exists() || await file.length() == 0) {
      return null;
    }

    print('✅ Video copied to: $filePath');
    print('   File size: ${await file.length()} bytes');
    return file;
  } catch (e) {
    print('❌ Error in copyAssetToTemp: $e');
    return null;
  }
}

Future<WinVideoPlayerController?> createAndInitializeController(
  dynamic file, {
  VoidCallback? onCompleted,
}) async {
  try {
    final controller = WinVideoPlayerController.file(file as File);

    await controller.initialize().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw Exception('Video initialization timeout');
          },
        );

    if (controller.value.isInitialized) {
      controller.setLooping(true);
      controller.setVolume(1.0);

      // Handle auto-loop on completion
      controller.addListener(() {
        if (controller.value.isCompleted) {
          controller.seekTo(Duration.zero);
          controller.play();
        }
      });

      print('✅ Video initialized successfully!');
      print('   Duration: ${controller.value.duration}');
      print('   Size: ${controller.value.size}');
      print('   Aspect Ratio: ${controller.value.aspectRatio}');
    }

    return controller;
  } catch (e) {
    print('❌ Error creating controller: $e');
    return null;
  }
}

bool isPlaying(dynamic controller) {
  if (controller is WinVideoPlayerController) {
    return controller.value.isInitialized && controller.value.isPlaying;
  }
  return false;
}

void play(dynamic controller) {
  if (controller is WinVideoPlayerController) {
    controller.play();
  }
}

void pause(dynamic controller) {
  if (controller is WinVideoPlayerController) {
    controller.pause();
  }
}

void seekTo(dynamic controller, Duration position) {
  if (controller is WinVideoPlayerController && controller.value.isInitialized) {
    controller.seekTo(position);
  }
}

void addListener(dynamic controller, VoidCallback listener) {
  if (controller is WinVideoPlayerController) {
    controller.addListener(listener);
  }
}

void dispose(dynamic controller) {
  if (controller is WinVideoPlayerController) {
    try {
      if (controller.value.isInitialized && controller.value.isPlaying) {
        controller.pause();
      }
      controller.dispose();
    } catch (e) {
      print('   Dispose error: $e');
    }
  }
}

Future<void> deleteTempFile(dynamic file) async {
  if (file is File) {
    try {
      if (await file.exists()) {
        await file.delete();
        print('   Deleted: ${file.path}');
      }
    } catch (e) {
      print('   Delete failed: ${file.path}');
    }
  }
}

/// Build a native video player widget
Widget buildVideoPlayer(dynamic controller) {
  if (controller is WinVideoPlayerController && controller.value.isInitialized) {
    return WinVideoPlayer(controller);
  }
  return const Center(
    child: CircularProgressIndicator(color: Colors.white),
  );
}
