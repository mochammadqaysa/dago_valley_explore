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
            Positioned.fill(child: _buildPanoramaViewer()),
            // Top-left close button
            Positioned(top: 12, left: 12, child: _buildCloseButton()),
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
              latitude: -20,
              longitude: 57.0,
              width: 700,
              height: 700,
              widget: Column(
                children: [
                  Image.asset(
                    "assets/gifs/arrow_up.gif",
                    width: 900,
                    height: 900,
                  ),
                ],
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
}
