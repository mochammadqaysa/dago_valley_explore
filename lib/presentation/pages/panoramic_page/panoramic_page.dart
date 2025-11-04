import 'dart:io';
import 'dart:ui';
import 'package:dago_valley_explore/presentation/controllers/locale/locale_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/panoramic/panoramic_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PanoramicPage extends GetView<PanoramicController> {
  const PanoramicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Close button
            _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  // Close button
  Widget _buildCloseButton() {
    return Padding(
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
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Carousel section
  Widget _buildPanoramicView() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 60,
            bottom: 60,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width,
              maxHeight: double.infinity,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                child: AspectRatio(
                  aspectRatio: 17 / 10,
                  child: _buildPanoramaViewer(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanoramaViewer() {
    return Obx(() {
      try {
        return PanoramaViewer(
          animSpeed: 0.1,
          sensorControl: controller.isDesktop
              ? SensorControl.none
              : SensorControl.orientation,
          onViewChanged: controller.onViewChanged,
          onTap: controller.onPanoramaTap,
          hotspots: [
            Hotspot(
              latitude: 0.0,
              longitude: 0.0,
              width: 90,
              height: 80,
              widget: _buildHotspotButton(
                text: "Next",
                icon: Icons.open_in_new,
                onPressed: controller.goToNextPanorama,
              ),
            ),
          ],
          child: controller.currentPanoAsset,
        );
      } catch (e, st) {
        debugPrint('PanoramaViewer failed: $e\n$st');
        return _buildPanoramaFallback();
      }
    });
  }

  // Build panorama fallback
  Widget _buildPanoramaFallback() {
    return Obx(
      () => Stack(
        fit: StackFit.expand,
        children: [
          controller.currentPanoAsset,
          const Center(
            child: Text(
              'Panorama unavailable',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // Build hotspot button
  Widget _buildHotspotButton({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(const CircleBorder()),
            backgroundColor: WidgetStateProperty.all(Colors.black38),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          onPressed: onPressed,
          child: Icon(icon),
        ),
        if (text != null)
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Center(child: Text(text)),
          ),
      ],
    );
  }

  // Thumbnail navigation
  Widget _buildThumbnailNavigation() {
    return SizedBox(
      height: 180,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.promos.length,
          itemBuilder: (context, index) {
            final isActive = index == controller.currentIndex;
            final promo = controller.promos[index];

            return GestureDetector(
              onTap: () => controller.goToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Opacity(
                    opacity: isActive ? 1.0 : 0.5,
                    child: _buildPromoImage(
                      promo.imageUrl,
                      fit: BoxFit.cover,
                      height: 180,
                      width: 120,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Build promo image with controller logic
  Widget _buildPromoImage(
    String imageUrl, {
    BoxFit fit = BoxFit.cover,
    double? height,
    double? width,
  }) {
    return Obx(() {
      // Check loading state
      if (controller.isImageLoading(imageUrl)) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      // Check if file exists in cache
      final file = controller.getCachedImageFile(imageUrl);
      if (controller.fileExists(file)) {
        return Image.file(file!, fit: fit, width: width, height: height);
      }

      // Try to load as asset
      if (imageUrl.isNotEmpty) {
        return Image.asset(
          imageUrl,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: const Center(child: Icon(Icons.broken_image)),
            );
          },
        );
      }

      // Fallback: no image
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.image_not_supported)),
      );
    });
  }
}
