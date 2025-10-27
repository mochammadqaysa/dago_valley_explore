import 'package:dago_valley_explore/presentation/controllers/virtualtour/detailproduct/detail_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'dart:ui';

class ProductDetailPage extends GetView<DetailProductController> {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ScrollController untuk thumbnail list
    final ScrollController thumbnailScrollController = ScrollController();

    // Function untuk auto scroll thumbnail
    void scrollThumbnailToIndex(int index) {
      if (thumbnailScrollController.hasClients) {
        const double thumbnailWidth = 110.0; // width (100) + margin (10)
        final double screenWidth = MediaQuery.of(context).size.width;
        final double maxScroll =
            thumbnailScrollController.position.maxScrollExtent;

        // Calculate target scroll position
        double targetScroll =
            (index * thumbnailWidth) - (screenWidth / 2) + (thumbnailWidth / 2);

        // Clamp between 0 and maxScrollExtent
        targetScroll = targetScroll.clamp(0.0, maxScroll);

        // Animate to target position
        thumbnailScrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        thumbnailScrollController.dispose(); // Dispose controller
        controller.closeModal();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Obx(() {
          // Check if images are loaded
          if (controller.images.isEmpty) {
            return Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: Colors.black.withOpacity(0.8)),
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
                  child: Container(color: Colors.black.withOpacity(0.8)),
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
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.houseModel.value!.model,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    controller.houseModel.value!.type,
                                    style: const TextStyle(color: Colors.white),
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
                          margin: const EdgeInsets.symmetric(horizontal: 20),
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
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
                                          // Auto scroll thumbnail when carousel changes
                                          scrollThumbnailToIndex(index);
                                        },
                                      ),
                                      itemBuilder: (context, index, realIndex) {
                                        return Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                          ),
                                          child: Image.asset(
                                            controller.images[index],
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.broken_image,
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                          size: 64,
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Text(
                                                          'Gambar tidak ditemukan',
                                                          style: TextStyle(
                                                            color: Colors.white
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
                                    controller:
                                        thumbnailScrollController, // Add ScrollController
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
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: isActive
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(
                                                      0.3,
                                                    ),
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                                                        color: Colors.grey[800],
                                                        child: Icon(
                                                          Icons.broken_image,
                                                          color: Colors.white
                                                              .withOpacity(0.3),
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
      ),
    );
  }
}
