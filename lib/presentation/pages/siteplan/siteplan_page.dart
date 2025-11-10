import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/siteplan_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class SiteplanPage extends GetView<SiteplanController> {
  const SiteplanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: double.infinity,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Obx(() {
                  return Container(
                    color: themeController.isDarkMode
                        ? Colors.black
                        : Colors.white,
                    child: AspectRatio(
                      aspectRatio: 17 / 10,
                      // child: _buildPanoramaViewer(),
                      child: ComingSoonSitePlan(isWide: true),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Build panorama viewer
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

  // Build floating action button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => controller.showSitePlanModal(),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.map, color: Colors.white),
    );
  }
}

// ============================================
// COMING SOON WIDGET - Separate Component
// ============================================
class ComingSoonSitePlan extends StatelessWidget {
  const ComingSoonSitePlan({super.key, required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isWide ? 900 : 600),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/time.svg", colorFilter: null),
            const SizedBox(height: 20),
            Text(
              'siteplan_feature'.tr,
              style: TextStyle(
                fontSize: isWide ? 28 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'siteplan_feature_desc'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isWide ? 16 : 14),
            ),
          ],
        ),
      ),
    );
  }
}
