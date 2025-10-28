import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Conditional imports
import 'package:video_player/video_player.dart'
    if (dart.library.io) 'package:video_player/video_player.dart';
import 'package:media_kit/media_kit.dart'
    if (dart.library.io) 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart'
    if (dart.library.io) 'package:media_kit_video/media_kit_video.dart';

class DetailProductController extends GetxController {
  final carouselController = cs.CarouselSliderController();
  final currentIndex = 0.obs;
  final isFullscreen = false.obs;
  final transformationController = TransformationController();
  final Rx<HouseModel?> houseModel = Rx<HouseModel?>(null);
  final RxList<String> images = <String>[].obs;
  final RxList<String> videos = <String>[].obs;

  int get totalItems => images.length + videos.length;

  // For Windows (media_kit)
  final Map<int, Player?> mediaKitPlayers = {};
  final Map<int, VideoController?> mediaKitControllers = {};

  // For Mobile (video_player)
  final Map<int, VideoPlayerController?> videoPlayerControllers = {};

  final RxMap<int, bool> videoInitialized = <int, bool>{}.obs;
  final RxMap<int, bool> videoPlaying = <int, bool>{}.obs;
  final RxMap<int, String?> videoErrors = <int, String?>{}.obs;
  final List<File> _tempVideoFiles = [];

  bool get supportsVideo => !kIsWeb;

  bool get isWindows {
    if (kIsWeb) return false;
    try {
      return Platform.isWindows;
    } catch (e) {
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Initialize media_kit for Windows
    if (isWindows && !kIsWeb) {
      try {
        MediaKit.ensureInitialized();
        print('✅ MediaKit initialized for Windows');
      } catch (e) {
        print('❌ MediaKit init error: $e');
      }
    }

    if (Get.arguments != null && Get.arguments is HouseModel) {
      houseModel.value = Get.arguments as HouseModel;
      images.value = houseModel.value?.gambar ?? [];
      videos.value = houseModel.value?.video ?? [];

      print('📊 Media loaded:');
      print('   Images: ${images.length}');
      print('   Videos: ${videos.length}');

      if (videos.isNotEmpty && supportsVideo) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            _initializeVideoPlayers();
          }
        });
      }
    }
  }

  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<File?> _copyAssetToTemp(String assetPath) async {
    try {
      print('📦 Copying asset: $assetPath');

      final exists = await _checkAssetExists(assetPath);
      if (!exists) {
        print('❌ Asset not found');
        return null;
      }

      final tempDir = await getTemporaryDirectory();
      final fileName = assetPath.split('/').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath =
          '${tempDir.path}${Platform.pathSeparator}video_$timestamp\_$fileName';

      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      if (!await file.exists() || await file.length() == 0) {
        print('❌ File creation failed');
        return null;
      }

      print('✅ Copied: ${bytes.length} bytes');
      _tempVideoFiles.add(file);
      return file;
    } catch (e) {
      print('❌ Copy error: $e');
      return null;
    }
  }

  void _initializeVideoPlayers() async {
    print('\n🎬 Initializing videos...');
    print(
      '   Platform: ${isWindows ? "Windows (MediaKit)" : "Mobile (VideoPlayer)"}',
    );

    for (int i = 0; i < videos.length; i++) {
      final videoIndex = images.length + i;
      final videoPath = videos[i];

      try {
        videoInitialized[videoIndex] = false;
        videoPlaying[videoIndex] = false;
        videoErrors[videoIndex] = null;

        print('\n📹 Video $i: $videoPath');

        if (isWindows) {
          // Windows: Use media_kit
          await _initializeMediaKit(videoIndex, videoPath);
        } else {
          // Mobile: Use video_player
          await _initializeVideoPlayer(videoIndex, videoPath);
        }

        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e, stackTrace) {
        videoErrors[videoIndex] = 'Error: $e';
        videoInitialized[videoIndex] = false;
        print('❌ Exception: $e');
      }
    }

    print('\n✅ Initialization complete\n');
  }

  Future<void> _initializeMediaKit(int videoIndex, String videoPath) async {
    try {
      print('   🪟 Using MediaKit...');

      final tempFile = await _copyAssetToTemp(videoPath);
      if (tempFile == null) {
        throw Exception('Failed to copy video');
      }

      // Create player
      final player = Player();
      final controller = VideoController(player);

      mediaKitPlayers[videoIndex] = player;
      mediaKitControllers[videoIndex] = controller;

      // Open media
      await player.open(Media(tempFile.path));

      // Wait for video to be ready
      await Future.delayed(const Duration(milliseconds: 500));

      // Set loop
      await player.setPlaylistMode(PlaylistMode.loop);

      // Listen to playing state
      player.stream.playing.listen((playing) {
        if (!isClosed) {
          videoPlaying[videoIndex] = playing;
        }
      });

      videoInitialized[videoIndex] = true;
      print('✅ MediaKit initialized');
    } catch (e) {
      print('❌ MediaKit error: $e');
      videoErrors[videoIndex] = 'MediaKit error: $e';
      videoInitialized[videoIndex] = false;
    }
  }

  Future<void> _initializeVideoPlayer(int videoIndex, String videoPath) async {
    try {
      print('   📱 Using VideoPlayer...');

      final controller = VideoPlayerController.asset(videoPath);
      videoPlayerControllers[videoIndex] = controller;

      await controller.initialize();

      controller.setLooping(true);
      controller.setVolume(1.0);

      controller.addListener(() {
        if (!isClosed) {
          videoPlaying[videoIndex] = controller.value.isPlaying;
        }
      });

      videoInitialized[videoIndex] = true;
      print('✅ VideoPlayer initialized');
    } catch (e) {
      print('❌ VideoPlayer error: $e');
      videoErrors[videoIndex] = 'VideoPlayer error: $e';
      videoInitialized[videoIndex] = false;
    }
  }

  bool isVideo(int index) => index >= images.length;

  // Get controllers based on platform
  dynamic getVideoController(int index) {
    if (isWindows) {
      return mediaKitControllers[index];
    } else {
      return videoPlayerControllers[index];
    }
  }

  Player? getMediaKitPlayer(int index) => mediaKitPlayers[index];
  VideoPlayerController? getVideoPlayerController(int index) =>
      videoPlayerControllers[index];

  int getVideoIndex(int carouselIndex) => carouselIndex - images.length;

  void toggleVideoPlayback(int index) {
    try {
      if (!videoInitialized[index]!) return;

      if (isWindows) {
        // MediaKit
        final player = mediaKitPlayers[index];
        if (player != null) {
          player.playOrPause();
          print('${player.state.playing ? "⏸️" : "▶️"} MediaKit toggle');
        }
      } else {
        // VideoPlayer
        final controller = videoPlayerControllers[index];
        if (controller != null && controller.value.isInitialized) {
          if (controller.value.isPlaying) {
            controller.pause();
            print('⏸️ VideoPlayer pause');
          } else {
            controller.play();
            print('▶️ VideoPlayer play');
          }
        }
      }
    } catch (e) {
      print('❌ Toggle error: $e');
    }
  }

  void pauseAllVideos() {
    try {
      if (isWindows) {
        mediaKitPlayers.forEach((index, player) {
          if (player != null && player.state.playing) {
            player.pause();
          }
        });
      } else {
        videoPlayerControllers.forEach((index, controller) {
          if (controller != null &&
              controller.value.isInitialized &&
              controller.value.isPlaying) {
            controller.pause();
          }
        });
      }
    } catch (e) {
      print('❌ Pause all error: $e');
    }
  }

  Future<void> _cleanupTempFiles() async {
    if (_tempVideoFiles.isEmpty) return;

    try {
      print('🧹 Cleaning ${_tempVideoFiles.length} files...');
      for (final file in _tempVideoFiles) {
        try {
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Ignore delete errors
        }
      }
      _tempVideoFiles.clear();
    } catch (e) {
      print('Cleanup error: $e');
    }
  }

  @override
  void onClose() {
    try {
      print('\n🛑 Disposing...');

      if (isWindows) {
        // Dispose MediaKit
        mediaKitPlayers.forEach((index, player) {
          try {
            player?.dispose();
          } catch (e) {
            print('MediaKit dispose error: $e');
          }
        });
        mediaKitPlayers.clear();
        mediaKitControllers.clear();
      } else {
        // Dispose VideoPlayer
        videoPlayerControllers.forEach((index, controller) {
          try {
            controller?.dispose();
          } catch (e) {
            print('VideoPlayer dispose error: $e');
          }
        });
        videoPlayerControllers.clear();
      }

      _cleanupTempFiles();

      print('✅ Disposed\n');
    } catch (e) {
      print('❌ Dispose error: $e');
    }

    try {
      transformationController.dispose();
    } catch (e) {
      // Ignore
    }

    super.onClose();
  }

  void setCurrentIndex(int index) {
    pauseAllVideos();
    currentIndex.value = index;
  }

  void goToPage(int index) => carouselController.animateToPage(index);
  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    if (!isFullscreen.value) {
      transformationController.value = Matrix4.identity();
    }
  }

  void openFullscreen() => isFullscreen.value = true;
  void closeFullscreen() {
    isFullscreen.value = false;
    transformationController.value = Matrix4.identity();
  }

  void bookPromo() {
    if (houseModel.value != null) {
      Get.snackbar(
        'Booking',
        'Booking untuk ${houseModel.value!.model}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void closeModal() => Get.back();
}
