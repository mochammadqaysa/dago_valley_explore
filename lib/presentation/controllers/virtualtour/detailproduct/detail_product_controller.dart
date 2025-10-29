import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class DetailProductController extends GetxController {
  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final currentIndex = 0.obs;

  // Observable untuk fullscreen mode
  final isFullscreen = false.obs;

  // TransformationController untuk zoom
  final transformationController = TransformationController();

  // House model yang akan ditampilkan
  final Rx<HouseModel?> houseModel = Rx<HouseModel?>(null);

  // List gambar dari house model
  final RxList<String> images = <String>[].obs;

  // List video dari house model
  final RxList<String> videos = <String>[].obs;

  // Total items (images + videos)
  int get totalItems => images.length + videos.length;

  // Video player controllers map
  final Map<int, VideoPlayerController> videoControllers = {};

  // Observable untuk track video yang sedang playing
  final playingVideoIndex = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    // Ambil house model dari arguments
    if (Get.arguments != null && Get.arguments is HouseModel) {
      houseModel.value = Get.arguments as HouseModel;
      images.value = houseModel.value?.gambar ?? [];
      videos.value = houseModel.value?.video ?? [];

      // Initialize video controllers
      _initializeVideoControllers();
    }
  }

  @override
  void onClose() {
    transformationController.dispose();
    _disposeVideoControllers();
    super.onClose();
  }

  // Initialize video controllers
  void _initializeVideoControllers() {
    for (int i = 0; i < videos.length; i++) {
      final videoIndex = images.length + i;
      final controller = VideoPlayerController.asset(videos[i]);

      controller
          .initialize()
          .then((_) {
            update();
          })
          .catchError((error) {
            print('Error initializing video $i: $error');
          });

      controller.addListener(() {
        if (controller.value.position == controller.value.duration) {
          // Video selesai, pause
          controller.pause();
          controller.seekTo(Duration.zero);
        }
      });

      videoControllers[videoIndex] = controller;
    }
  }

  // Dispose video controllers
  void _disposeVideoControllers() {
    for (var controller in videoControllers.values) {
      controller.dispose();
    }
    videoControllers.clear();
  }

  // Check if index is video
  bool isVideoIndex(int index) {
    return index >= images.length;
  }

  // Get video controller for index
  VideoPlayerController? getVideoController(int index) {
    return videoControllers[index];
  }

  // Toggle video play/pause
  void toggleVideoPlayback(int index) {
    final controller = videoControllers[index];
    if (controller != null) {
      if (controller.value.isPlaying) {
        controller.pause();
        playingVideoIndex.value = null;
      } else {
        // Pause all other videos
        _pauseAllVideos();
        controller.play();
        playingVideoIndex.value = index;
      }
    }
  }

  // Pause all videos
  void _pauseAllVideos() {
    for (var controller in videoControllers.values) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }
    playingVideoIndex.value = null;
  }

  // Set index carousel
  void setCurrentIndex(int index) {
    // Pause video when leaving video slide
    if (isVideoIndex(currentIndex.value)) {
      _pauseAllVideos();
    }
    currentIndex.value = index;
  }

  // Go to specific page
  void goToPage(int index) {
    carouselController.jumpToPage(index);
  }

  // Toggle fullscreen mode
  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    // Reset zoom when exiting fullscreen
    if (!isFullscreen.value) {
      transformationController.value = Matrix4.identity();
    }
  }

  // Open fullscreen
  void openFullscreen() {
    // Don't allow fullscreen for videos
    if (!isVideoIndex(currentIndex.value)) {
      isFullscreen.value = true;
    }
  }

  // Close fullscreen
  void closeFullscreen() {
    isFullscreen.value = false;
    transformationController.value = Matrix4.identity();
  }

  // Handle booking action
  void bookPromo() {
    if (houseModel.value != null) {
      Get.snackbar(
        'Booking',
        'Booking untuk ${houseModel.value!.model}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Close modal
  void closeModal() {
    _pauseAllVideos();
    Get.back();
  }
}
