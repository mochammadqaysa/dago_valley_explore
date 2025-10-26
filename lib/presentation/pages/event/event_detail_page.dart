import 'package:dago_valley_explore/presentation/controllers/event/event_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/promo/promo_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:get/get.dart';
import 'dart:ui';

class EventDetailPage extends GetView<EventController> {
  const EventDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<EventController>(
      init: controller,
      initState: (state) {
        // Init jika diperlukan
      },
      builder: (_) {
        if (controller.promos.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.black87,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        return WillPopScope(
          onWillPop: () async {
            controller.closeModal();
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.black87,
            body: Stack(
              children: [
                // Background blur effect
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Image.asset(
                      controller.currentPromo.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                                onTap: controller.closeModal,
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
                          ],
                        ),
                      ),

                      // Main Content
                      Expanded(
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left Side - Carousel
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Main Carousel
                                      Container(
                                        height: 800,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: Colors.black.withOpacity(
                                          //       0.3,
                                          //     ),
                                          //     blurRadius: 20,
                                          //     offset: const Offset(0, 10),
                                          //   ),
                                          // ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: cs.CarouselSlider.builder(
                                            carouselController:
                                                controller.carouselController,
                                            itemCount: controller.promos.length,
                                            options: cs.CarouselOptions(
                                              height: 800,
                                              viewportFraction: 1.0,
                                              enlargeCenterPage: false,
                                              autoPlay: false,
                                              enableInfiniteScroll: false,
                                              onPageChanged: (index, reason) {
                                                controller.setCurrentIndex(
                                                  index,
                                                );
                                              },
                                            ),
                                            itemBuilder: (context, index, realIndex) {
                                              return Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  Image.asset(
                                                    controller
                                                        .promos[index]
                                                        .imageUrl,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  // Gradient overlay
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          // Colors
                                                          //     .transparent,
                                                          // Colors.black
                                                          //     .withOpacity(
                                                          //       0.3,
                                                          //     ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 40),

                                // Right Side - Content
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(30),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 10,
                                          sigmaY: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // HANYA TEKS & BUTTON YANG BERUBAH
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Container(
                                                key: ValueKey(
                                                  controller.currentIndex,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      controller
                                                          .currentPromo
                                                          .title,
                                                      style: const TextStyle(
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      controller
                                                          .currentPromo
                                                          .subtitle,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 24),
                                                    Text(
                                                      controller
                                                          .currentPromo
                                                          .description,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 50),
                                                    // Wrap(
                                                    //   spacing: 10,
                                                    //   runSpacing: 10,
                                                    //   children: [
                                                    //     _buildTag(
                                                    //       controller
                                                    //           .currentPromo
                                                    //           .tag1,
                                                    //       Colors.teal,
                                                    //     ),
                                                    //     _buildTag(
                                                    //       controller
                                                    //           .currentPromo
                                                    //           .tag2,
                                                    //       Colors.green,
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    // SizedBox(
                                                    //   width: double.infinity,
                                                    //   height: 56,
                                                    //   child: ElevatedButton(
                                                    //     onPressed: controller
                                                    //         .bookPromo,
                                                    //     style: ElevatedButton.styleFrom(
                                                    //       backgroundColor:
                                                    //           Colors.teal,
                                                    //       foregroundColor:
                                                    //           Colors.white,
                                                    //       shape: RoundedRectangleBorder(
                                                    //         borderRadius:
                                                    //             BorderRadius.circular(
                                                    //               30,
                                                    //             ),
                                                    //       ),
                                                    //       elevation: 5,
                                                    //     ),
                                                    //     child: const Text(
                                                    //       'Booking Sekarang',
                                                    //       style: TextStyle(
                                                    //         fontSize: 18,
                                                    //         fontWeight:
                                                    //             FontWeight.bold,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 30),

                                            SizedBox(
                                              height: 180,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    controller.promos.length,
                                                itemBuilder: (context, index) {
                                                  final isActive =
                                                      index ==
                                                      controller.currentIndex;
                                                  return GestureDetector(
                                                    onTap: () => controller
                                                        .goToPage(index),
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      width: 120,
                                                      margin:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        border: Border.all(
                                                          color: isActive
                                                              ? Colors.white
                                                              : Colors
                                                                    .transparent,
                                                          width: 3,
                                                        ),
                                                        boxShadow: isActive
                                                            ? [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                        0.3,
                                                                      ),
                                                                  blurRadius:
                                                                      10,
                                                                  spreadRadius:
                                                                      2,
                                                                ),
                                                              ]
                                                            : null,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        child: Opacity(
                                                          opacity: isActive
                                                              ? 1.0
                                                              : 0.5,
                                                          child: Image.asset(
                                                            controller
                                                                .promos[index]
                                                                .imageUrl,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
