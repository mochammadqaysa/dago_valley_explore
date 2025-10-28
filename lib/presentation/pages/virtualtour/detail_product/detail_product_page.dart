import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/virtualtour/detailproduct/detail_product_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui';

class ProductDetailPage extends GetView<DetailProductController> {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final ScrollController thumbnailScrollController = ScrollController();

    void scrollThumbnailToIndex(int index) {
      if (thumbnailScrollController.hasClients) {
        const double thumbnailWidth = 110.0;
        final double screenWidth = MediaQuery.of(context).size.width;
        final double maxScroll =
            thumbnailScrollController.position.maxScrollExtent;

        double targetScroll =
            (index * thumbnailWidth) - (screenWidth / 2) + (thumbnailWidth / 2);

        targetScroll = targetScroll.clamp(0.0, maxScroll);

        thumbnailScrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (controller.isFullscreen.value) {
          controller.closeFullscreen();
          return false;
        }
        controller.pauseAllVideos();
        thumbnailScrollController.dispose();
        controller.closeModal();
        return false;
      },
      child: Scaffold(
        backgroundColor: themeController.isDarkMode
            ? Colors.black
            : Colors.white,
        body: Stack(
          children: [
            Obx(() {
              if (controller.totalItems == 0) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: themeController.isDarkMode
                              ? Colors.black.withOpacity(0.8)
                              : Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ],
                );
              }

              return Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: themeController.isDarkMode
                            ? Colors.black.withOpacity(0.8)
                            : Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        // Close Button & Title
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    controller.pauseAllVideos();
                                    thumbnailScrollController.dispose();
                                    controller.closeModal();
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: themeController.isDarkMode
                                          ? Colors.white.withOpacity(0.2)
                                          : Colors.black.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: themeController.isDarkMode
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.black.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (controller.houseModel.value != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.houseModel.value!.model,
                                        style: TextStyle(
                                          color: themeController.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        controller.houseModel.value!.type,
                                        style: TextStyle(
                                          color: themeController.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Main Carousel
                        Expanded(
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 1200),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CarouselSlider.builder(
                                          carouselController:
                                              controller.carouselController,
                                          itemCount: controller.totalItems,
                                          options: CarouselOptions(
                                            viewportFraction: 1.0,
                                            enlargeCenterPage: false,
                                            autoPlay: false,
                                            enableInfiniteScroll: false,
                                            onPageChanged: (index, reason) {
                                              controller.setCurrentIndex(index);
                                              scrollThumbnailToIndex(index);
                                            },
                                          ),
                                          itemBuilder:
                                              (context, index, realIndex) {
                                                final isVideo = controller
                                                    .isVideo(index);

                                                if (isVideo) {
                                                  return _buildVideoItem(
                                                    index,
                                                    themeController,
                                                  );
                                                } else {
                                                  return _buildImageItem(
                                                    index,
                                                    themeController,
                                                  );
                                                }
                                              },
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Thumbnails
                                  Obx(() {
                                    final currentIdx =
                                        controller.currentIndex.value;

                                    return Container(
                                      height: 120,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: ListView.builder(
                                        controller: thumbnailScrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.totalItems,
                                        itemBuilder: (context, index) {
                                          final isActive = index == currentIdx;
                                          final isVideo = controller.isVideo(
                                            index,
                                          );

                                          return GestureDetector(
                                            onTap: () {
                                              controller.goToPage(index);
                                              scrollThumbnailToIndex(index);
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              width: 100,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color:
                                                      themeController.isDarkMode
                                                      ? isActive
                                                            ? Colors.white
                                                            : Colors.white
                                                                  .withOpacity(
                                                                    0.3,
                                                                  )
                                                      : isActive
                                                      ? Colors.black
                                                      : Colors.black
                                                            .withOpacity(0.3),
                                                  width: isActive ? 3 : 1,
                                                ),
                                                boxShadow: isActive
                                                    ? [
                                                        BoxShadow(
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                          blurRadius: 10,
                                                          spreadRadius: 2,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Opacity(
                                                      opacity: isActive
                                                          ? 1.0
                                                          : 0.5,
                                                      child: isVideo
                                                          ? _buildVideoThumbnail(
                                                              index,
                                                            )
                                                          : Image.asset(
                                                              controller
                                                                  .images[index],
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (
                                                                    context,
                                                                    error,
                                                                    stackTrace,
                                                                  ) {
                                                                    return Container(
                                                                      color: Colors
                                                                          .grey[800],
                                                                      child: Icon(
                                                                        Icons
                                                                            .broken_image,
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(
                                                                              0.3,
                                                                            ),
                                                                      ),
                                                                    );
                                                                  },
                                                            ),
                                                    ),
                                                    if (isVideo)
                                                      Center(
                                                        child: Icon(
                                                          Icons
                                                              .play_circle_outline,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            // Fullscreen Overlay
            Obx(() {
              if (!controller.isFullscreen.value) {
                return const SizedBox.shrink();
              }
              return _buildFullscreenOverlay(context, themeController);
            }),
          ],
        ),
      ),
    );
  }

  // Build Image Item
  Widget _buildImageItem(int index, ThemeController themeController) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          controller.openFullscreen();
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeController.isDarkMode
                ? Colors.white.withOpacity(0.4)
                : Colors.transparent,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                controller.images[index],
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
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.zoom_in_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Klik untuk zoom',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Video Item
  Widget _buildVideoItem(int index, ThemeController themeController) {
    if (kIsWeb) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam_off,
                color: Colors.white.withOpacity(0.7),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Video tidak tersedia di Web',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Obx(() {
      final isInitialized = controller.videoInitialized[index] ?? false;
      final isPlaying = controller.videoPlaying[index] ?? false;
      final error = controller.videoErrors[index];

      if (error != null) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white.withOpacity(0.7),
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Video tidak dapat dimuat',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (!isInitialized) {
        return Container(
          color: Colors.black,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Memuat video...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      }

      return GestureDetector(
        onTap: () => controller.toggleVideoPlayback(index),
        child: Container(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: controller.isWindows
                    ? Video(controller: controller.getVideoController(index))
                    : AspectRatio(
                        aspectRatio: controller
                            .getVideoPlayerController(index)!
                            .value
                            .aspectRatio,
                        child: VideoPlayer(
                          controller.getVideoPlayerController(index)!,
                        ),
                      ),
              ),
              if (!isPlaying)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              // Controls overlay...
            ],
          ),
        ),
      );
    });
  }

  // Build Video Thumbnail
  Widget _buildVideoThumbnail(int index) {
    final videoController = controller.getVideoController(index);
    final isInitialized = controller.videoInitialized[index] ?? false;

    if (videoController == null || !isInitialized) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        ),
      );
    }

    return VideoPlayer(videoController);
  }

  Widget _buildFullscreenOverlay(
    BuildContext context,
    ThemeController themeController,
  ) {
    final currentIndex = controller.currentIndex.value;
    final isVideo = controller.isVideo(currentIndex);

    return Material(
      color: Colors.black.withOpacity(0.95),
      child: Stack(
        children: [
          Center(
            child: isVideo
                ? _buildFullscreenVideo(currentIndex)
                : InteractiveViewer(
                    transformationController:
                        controller.transformationController,
                    minScale: 0.5,
                    maxScale: 4.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Image.asset(
                      controller.images[currentIndex],
                      fit: BoxFit.contain,
                    ),
                  ),
          ),

          // Close Button
          Positioned(
            top: 40,
            right: 40,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.closeFullscreen,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),

          // Navigation Arrows
          if (controller.totalItems > 1) ...[
            Positioned(
              left: 40,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final newIndex = currentIndex > 0
                          ? currentIndex - 1
                          : controller.totalItems - 1;
                      controller.goToPage(newIndex);
                      controller.transformationController.value =
                          Matrix4.identity();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 40,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final newIndex = currentIndex < controller.totalItems - 1
                          ? currentIndex + 1
                          : 0;
                      controller.goToPage(newIndex);
                      controller.transformationController.value =
                          Matrix4.identity();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Info Text
          Positioned(
            bottom: 40,
            right: 30,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVideo ? Icons.videocam : Icons.gesture,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isVideo
                          ? 'Video ${currentIndex - controller.images.length + 1}/${controller.videos.length}'
                          : 'Pinch untuk zoom • ${currentIndex + 1}/${controller.totalItems}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullscreenVideo(int index) {
    return Obx(() {
      final videoController = controller.getVideoController(index);
      final isInitialized = controller.videoInitialized[index] ?? false;
      final isPlaying = controller.videoPlaying[index] ?? false;

      if (videoController == null || !isInitialized) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      return GestureDetector(
        onTap: () {
          controller.toggleVideoPlayback(index);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: VideoPlayer(videoController),
              ),
            ),
            if (!isPlaying)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
