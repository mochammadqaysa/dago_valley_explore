import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/virtualtour/detailproduct/detail_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'dart:ui';

class ProductDetailPage extends GetView<DetailProductController> {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    // ScrollController untuk thumbnail list
    final ScrollController thumbnailScrollController = ScrollController();

    // Function untuk auto scroll thumbnail
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
        // Check if fullscreen is active
        if (controller.isFullscreen.value) {
          controller.closeFullscreen();
          return false;
        }
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
            // Main Content
            Obx(() {
              if (controller.images.isEmpty) {
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
                  // Background blur effect
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

                  // Content
                  SafeArea(
                    child: Column(
                      children: [
                        // Close Button
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
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
                              // Title
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

                        // Main Content
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
                                  // Main Image Display (Large)
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
                                          itemCount: controller.images.length,
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
                                          itemBuilder: (context, index, realIndex) {
                                            return MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.openFullscreen();
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        themeController
                                                            .isDarkMode
                                                        ? Colors.white
                                                              .withOpacity(0.4)
                                                        : Colors.transparent,
                                                  ),
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      Image.asset(
                                                        controller
                                                            .images[index],
                                                        fit: BoxFit.contain,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) {
                                                              return Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .broken_image,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                            0.5,
                                                                          ),
                                                                      size: 64,
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    Text(
                                                                      'Gambar tidak ditemukan',
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(
                                                                              0.7,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                      ),
                                                      // Hover overlay dengan icon zoom
                                                      Positioned(
                                                        bottom: 16,
                                                        right: 16,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                12,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.6,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  30,
                                                                ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .zoom_in_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                'Klik untuk zoom',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
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
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Gallery Thumbnails (Bottom)
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
                                        itemCount: controller.images.length,
                                        itemBuilder: (context, index) {
                                          final isActive = index == currentIdx;
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
                                                child: Opacity(
                                                  opacity: isActive ? 1.0 : 0.5,
                                                  child: Image.asset(
                                                    controller.images[index],
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

            // Fullscreen Overlay dengan Zoom
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

  // Widget untuk fullscreen overlay dengan zoom
  Widget _buildFullscreenOverlay(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Material(
      color: Colors.grey.withOpacity(0.95),
      child: Stack(
        children: [
          // Interactive Viewer untuk zoom
          Center(
            child: InteractiveViewer(
              transformationController: controller.transformationController,
              minScale: 0.5,
              maxScale: 4.0,
              panEnabled: true,
              scaleEnabled: true,
              child: Image.asset(
                controller.images[controller.currentIndex.value],
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
          if (controller.images.length > 1) ...[
            // Previous Button
            Positioned(
              left: 40,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final newIndex = controller.currentIndex.value > 0
                          ? controller.currentIndex.value - 1
                          : controller.images.length - 1;
                      controller.goToPage(newIndex);
                      // Reset zoom saat ganti gambar
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

            // Next Button
            Positioned(
              right: 40,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final newIndex =
                          controller.currentIndex.value <
                              controller.images.length - 1
                          ? controller.currentIndex.value + 1
                          : 0;
                      controller.goToPage(newIndex);
                      // Reset zoom saat ganti gambar
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

          // Info Text (Bottom Center)
          Positioned(
            bottom: 40,
            // left: 0,
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
                    Icon(Icons.gesture, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Pinch untuk zoom • ${controller.currentIndex.value + 1}/${controller.images.length}',
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
}
