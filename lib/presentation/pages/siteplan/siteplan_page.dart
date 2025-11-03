import 'dart:io' as io;
import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/detailsiteplan/detail_siteplan_binding.dart';
import 'package:dago_valley_explore/presentation/pages/qrcode/qrcode_page.dart';
import 'package:dago_valley_explore/presentation/pages/siteplan/detail_siteplan/detail_siteplan_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class SiteplanPage extends StatefulWidget {
  const SiteplanPage({Key? key}) : super(key: key);

  @override
  State<SiteplanPage> createState() => _SiteplanPageState();
}

class _SiteplanPageState extends State<SiteplanPage> {
  void _showNotifySnack() {
    Get.snackbar(
      'Terima Kasih',
      'Kami akan memberi tahu Anda saat fitur Siteplan tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void _showSitePlanModal([String? url]) {
    // If caller didn't pass URL, try get from local storage (Brochure list)
    if (url == null || url.isEmpty) {
      try {
        final storage = Get.find<LocalStorageService>();
        // Adjust property name if your LocalStorageService uses a different field.
        final brochures = storage.brochures;
        if (kDebugMode)
          print('Fetched brochures from local storage: $brochures');
        if (brochures != null && brochures.isNotEmpty) {
          final first = brochures.first;
          url = (first.imageUrl ?? '').toString();
        }
      } catch (e) {
        if (kDebugMode)
          print('Error fetching brochures from local storage: $e');
      }
    }

    if (url == null || url.isEmpty) {
      Get.snackbar(
        'QR Code',
        'Tidak ada URL brochure yang tersedia.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Debug log
    if (kDebugMode) print('Opening Siteplan detail modal with url: $url');

    // Navigate to SiteplanDetailPage and pass the url via arguments; binding will create controller with this arg
    Get.to(
      () => const SiteplanDetailPage(),
      binding: DetailSiteplanBinding(),
      arguments: url,
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  bool _showDebugInfo = false;
  double _lon = 0;
  double _lat = 0;
  double _tilt = 0;
  int _panoId = 0;

  List<Image> panoAssets = [
    Image.asset('assets/panorama1.webp', fit: BoxFit.cover),
    Image.asset('assets/panorama2.webp', fit: BoxFit.cover),
    Image.asset('assets/panorama3.webp', fit: BoxFit.cover),
  ];

  void onViewChanged(longitude, latitude, tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }

  Widget hotspotButton({
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
        text != null
            ? Container(
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Center(child: Text(text)),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    // Because app is Windows-only, disable sensor/gyroscope control on desktop.
    // If you later support mobile, change logic to allow orientation on mobile.
    final bool isDesktop =
        !kIsWeb &&
        (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS);
    final SensorControl sensorControl = isDesktop
        ? SensorControl.none
        : SensorControl.orientation;

    // Build panorama widget based on current pano id
    Widget panorama;
    final asset = panoAssets[_panoId % panoAssets.length];

    // Use try/catch to avoid unexpected plugin calls throwing during runtime
    try {
      panorama = PanoramaViewer(
        animSpeed: 0.1,
        sensorControl: sensorControl,
        onViewChanged: onViewChanged,
        onTap: (longitude, latitude, tilt) =>
            debugPrint('onTap: $longitude, $latitude, $tilt'),
        hotspots: [
          Hotspot(
            latitude: 0.0,
            longitude: 0.0,
            width: 90,
            height: 80,
            widget: hotspotButton(
              text: "Next",
              icon: Icons.open_in_new,
              onPressed: () =>
                  setState(() => _panoId = (_panoId + 1) % panoAssets.length),
            ),
          ),
        ],
        child: asset,
      );
    } catch (e, st) {
      // Fallback: if panorama plugin fails for any reason, show a plain image with basic controls
      debugPrint('PanoramaViewer failed: $e\n$st');
      panorama = Stack(
        fit: StackFit.expand,
        children: [
          asset,
          Center(
            child: Text(
              'Panorama unavailable',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(
                  context,
                ).size.width, // atur lebar maksimal
                maxHeight: double.infinity, // atur tinggi maksimal
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black,
                  child: AspectRatio(
                    aspectRatio:
                        17 / 10, // atau ubah sesuai rasio panorama Anda
                    child: panorama,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSitePlanModal(), // <-- call the function
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.map, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

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
