import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/app/util/platform_helper.dart';
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Conditional import for video player operations
import 'detail_product_video_stub.dart'
    if (dart.library.io) 'detail_product_video_io.dart' as video_impl;

class DetailProductController extends GetxController {
  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // PageController untuk fullscreen overlay
  PageController? pageController;

  // Observable untuk index aktif
  final currentIndex = 0.obs;

  // Observable untuk fullscreen mode
  final isFullscreen = false.obs;

  // TransformationController untuk zoom
  final transformationController = TransformationController();

  // House model yang akan ditampilkan
  final Rx<HouseModel?> houseModel = Rx<HouseModel?>(null);

  // List gambar dan video dari house model
  final RxList<String> images = <String>[].obs;
  final RxList<String> videos = <String>[].obs;

  // Total items (images + videos)
  int get totalItems => images.length + videos.length;

  // Start index for carousel (skip first image if images exist)
  int get startIndex => images.isNotEmpty ? 1 : 0;

  // Video players (dynamic to support both web stub and native types)
  final Map<int, dynamic> videoControllers = {};
  final RxMap<int, bool> videoInitialized = <int, bool>{}.obs;
  final RxMap<int, bool> videoPlaying = <int, bool>{}.obs;
  final RxMap<int, String?> videoErrors = <int, String?>{}.obs;

  // Track copied video files (dynamic - File on native, null on web)
  final List<dynamic> _tempVideoFiles = [];

  // Check if platform supports video
  bool get supportsVideo {
    if (kIsWeb) return false;
    return PlatformHelper.isWindows;
  }

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is HouseModel) {
      houseModel.value = Get.arguments as HouseModel;
      images.value = houseModel.value?.gambar ?? [];
      videos.value = houseModel.value?.video ?? [];

      print('📊 Product Detail Loaded:');
      print('   Model: ${houseModel.value?.model}');
      print('   Type: ${houseModel.value?.type}');
      print('   Images: ${images.length}');
      print('   Videos: ${videos.length}');

      // Initialize videos if available and on Windows
      if (videos.isNotEmpty && supportsVideo) {
        // Delay to avoid startup conflicts
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!isClosed) {
            _initializeVideoPlayers();
          }
        });
      }
    }
  }

  void pauseVideo(int index) {
    final videoController = getVideoController(index);
    if (videoController != null && video_impl.isPlaying(videoController)) {
      video_impl.pause(videoController);
      videoPlaying[index] = false;
    }
  }

  // Check if asset exists
  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Copy asset to temp directory (only on native)
  Future<dynamic> _copyAssetToTemp(String assetPath) async {
    if (kIsWeb) return null;
    try {
      print('📦 Copying video asset: $assetPath');

      final exists = await _checkAssetExists(assetPath);
      if (!exists) {
        print('❌ Asset not found: $assetPath');
        return null;
      }

      print('   Loading asset bytes...');
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      print('   Writing ${bytes.length} bytes to temp file...');
      final file = await video_impl.copyAssetToTemp(assetPath, bytes);

      if (file == null) {
        print('❌ Failed to create temp file');
        return null;
      }

      _tempVideoFiles.add(file);
      return file;
    } catch (e, stackTrace) {
      print('❌ Error copying asset: $e');
      print('   Stack: $stackTrace');
      return null;
    }
  }

  // Initialize video players
  void _initializeVideoPlayers() async {
    if (!supportsVideo) return;

    print('\n🎬 Initializing ${videos.length} video(s)...');

    for (int i = 0; i < videos.length; i++) {
      final videoIndex = images.length + i;
      final videoPath = videos[i];

      try {
        videoInitialized[videoIndex] = false;
        videoPlaying[videoIndex] = false;
        videoErrors[videoIndex] = null;

        print('\n📹 Video $i: $videoPath');

        // Copy asset to temp file
        final tempFile = await _copyAssetToTemp(videoPath);
        if (tempFile == null) {
          throw Exception('Failed to copy video to temp directory');
        }

        // Create and initialize controller via platform impl
        print('   Creating VideoPlayerController...');
        final controller = await video_impl.createAndInitializeController(
          tempFile,
          onCompleted: () {
            if (!isClosed) {
              print('   Video completed, restarting...');
            }
          },
        );

        if (controller == null) {
          throw Exception('Failed to create video controller');
        }

        videoControllers[videoIndex] = controller;

        if (!isClosed) {
          videoInitialized[videoIndex] = true;

          // Add playback state listener
          video_impl.addListener(controller, () {
            if (!isClosed && videoControllers[videoIndex] != null) {
              final isPlaying = video_impl.isPlaying(controller);
              if (videoPlaying[videoIndex] != isPlaying) {
                videoPlaying[videoIndex] = isPlaying;
              }
            }
          });

          print('✅ Video initialized successfully!');
        }

        // Delay between initializations
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e, stackTrace) {
        if (!isClosed) {
          final errorMsg = 'Exception: $e';
          videoErrors[videoIndex] = errorMsg;
          videoInitialized[videoIndex] = false;
          print('❌ $errorMsg');
          print('   Stack: $stackTrace');
        }
      }
    }

    print('\n✅ Video initialization complete\n');
  }

  // Check if current item is video
  bool isVideo(int index) => index >= images.length;

  // Get video controller
  dynamic getVideoController(int index) => videoControllers[index];

  // Get video index
  int getVideoIndex(int carouselIndex) => carouselIndex - images.length;

  // Toggle video playback
  void toggleVideoPlayback(int index) {
    try {
      final controller = videoControllers[index];
      if (controller != null && videoInitialized[index] == true) {
        if (video_impl.isPlaying(controller)) {
          video_impl.pause(controller);
          print('⏸️ Video paused at index $index');
        } else {
          video_impl.play(controller);
          print('▶️ Video playing at index $index');
        }
      } else {
        print('⚠️ Cannot toggle video at index $index - not initialized');
      }
    } catch (e) {
      print('❌ Error toggling playback: $e');
    }
  }

  // Pause all videos
  void pauseAllVideos() {
    try {
      videoControllers.forEach((index, controller) {
        if (controller != null) {
          try {
            if (video_impl.isPlaying(controller)) {
              video_impl.pause(controller);
            }
          } catch (e) {
            print('Error pausing video $index: $e');
          }
        }
      });
    } catch (e) {
      print('❌ Error pausing videos: $e');
    }
  }

  // Seek video
  void seekVideo(int index, Duration position) {
    try {
      final controller = videoControllers[index];
      if (controller != null) {
        video_impl.seekTo(controller, position);
      }
    } catch (e) {
      print('❌ Error seeking: $e');
    }
  }

  // Cleanup temp files
  Future<void> _cleanupTempFiles() async {
    if (_tempVideoFiles.isEmpty) return;
    if (kIsWeb) return;

    try {
      print('🧹 Cleaning ${_tempVideoFiles.length} temp file(s)...');
      for (final file in _tempVideoFiles) {
        await video_impl.deleteTempFile(file);
      }
      _tempVideoFiles.clear();
      print('✅ Cleanup complete');
    } catch (e) {
      print('❌ Cleanup error: $e');
    }
  }

  @override
  void onClose() {
    try {
      print('\n🛑 Disposing controllers...');

      // Dispose video controllers
      final indices = videoControllers.keys.toList();
      for (final index in indices) {
        final controller = videoControllers[index];
        if (controller != null) {
          try {
            video_impl.dispose(controller);
            print('   Disposed controller at index $index');
          } catch (e) {
            print('   Dispose error for index $index: $e');
          }
        }
      }
      videoControllers.clear();

      // Cleanup temp files
      _cleanupTempFiles();

      print('✅ All controllers disposed\n');
    } catch (e) {
      print('❌ onClose error: $e');
    }

    try {
      transformationController.dispose();
    } catch (e) {
      // Ignore
    }

    super.onClose();
  }

  // Set current index
  void setCurrentIndex(int index) {
    pauseAllVideos();
    currentIndex.value = index;
  }

  // Go to page
  void goToPage(int index) {
    carouselController.animateToPage(index);
  }

  // Open fullscreen
  void openFullscreen() {
    isFullscreen.value = true;

    // Calculate initial page based on visual index
    // currentIndex is the Data Index, convert to Visual Index
    int initialPage = 0;
    if (currentIndex.value >= startIndex) {
      initialPage = currentIndex.value - startIndex;
    }

    pageController = PageController(initialPage: initialPage);
  }

  // Close fullscreen
  void closeFullscreen() {
    isFullscreen.value = false;
    transformationController.value = Matrix4.identity();
    // Dispose PageController
    pageController?.dispose();
    pageController = null;
  }

  // Navigate to next page
  void nextPage() {
    // Calculate next Data Index
    int nextDataIndex = currentIndex.value + 1;

    // Wrap around logic
    if (nextDataIndex >= totalItems) {
      nextDataIndex = startIndex; // Loop back to first VISIBLE item
    }

    // Convert to Visual Index
    int visualIndex = nextDataIndex - startIndex;
    if (visualIndex < 0) visualIndex = 0;

    // Update PageController (Visual Index)
    if (isFullscreen.value && pageController != null) {
      pageController!.animateToPage(
        visualIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Update carousel utama (Visual Index)
    goToPage(visualIndex);
  }

  // Navigate to previous page
  void previousPage() {
    // Calculate previous Data Index
    int prevDataIndex = currentIndex.value - 1;

    // Wrap around logic
    if (prevDataIndex < startIndex) {
      prevDataIndex = totalItems - 1; // Go to last item
    }

    // Convert to Visual Index
    int visualIndex = prevDataIndex - startIndex;
    if (visualIndex < 0) visualIndex = 0;

    // Update PageController (Visual Index)
    if (isFullscreen.value && pageController != null) {
      pageController!.animateToPage(
        visualIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Update carousel utama (Visual Index)
    goToPage(visualIndex);
  }

  // Handle booking
  void bookPromo() {
    if (houseModel.value != null) {
      Get.snackbar(
        'Booking',
        'Booking untuk ${houseModel.value!.model}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Close modal
  void closeModal() {
    Get.back();
  }
}
