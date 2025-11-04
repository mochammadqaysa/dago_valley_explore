import 'dart:io' as io;
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/detailsiteplan/detail_siteplan_binding.dart';
import 'package:dago_valley_explore/presentation/pages/siteplan/detail_siteplan/detail_siteplan_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SiteplanController extends GetxController {
  SiteplanController();
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  // Panorama state
  final _panoId = 0.obs;
  int get panoId => _panoId.value;

  final _lon = 0.0.obs;
  double get lon => _lon.value;

  final _lat = 0.0.obs;
  double get lat => _lat.value;

  final _tilt = 0.0.obs;
  double get tilt => _tilt.value;

  final _showDebugInfo = false.obs;
  bool get showDebugInfo => _showDebugInfo.value;

  // Panorama assets
  final panoAssets = <Image>[
    Image.asset('assets/panorama1.webp', fit: BoxFit.cover),
    Image.asset('assets/panorama2.webp', fit: BoxFit.cover),
    Image.asset('assets/panorama3.webp', fit: BoxFit.cover),
  ];

  // Get current panorama asset
  Image get currentPanoAsset => panoAssets[_panoId.value % panoAssets.length];

  // Check if running on desktop
  bool get isDesktop {
    return !kIsWeb &&
        (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS);
  }

  @override
  void onInit() {
    super.onInit();
    _initializePanorama();
  }

  void _initializePanorama() {
    if (kDebugMode) {
      print('Initializing Siteplan Panorama');
    }
  }

  // Update panorama view
  void onViewChanged(double longitude, double latitude, double tilt) {
    _lon.value = longitude;
    _lat.value = latitude;
    _tilt.value = tilt;
  }

  // Handle panorama tap
  void onPanoramaTap(double longitude, double latitude, double tilt) {
    if (kDebugMode) {
      print('onTap: $longitude, $latitude, $tilt');
    }
  }

  // Go to next panorama
  void goToNextPanorama() {
    _panoId.value = (_panoId.value + 1) % panoAssets.length;
    if (kDebugMode) {
      print('Switched to panorama: ${_panoId.value}');
    }
  }

  // Go to previous panorama
  void goToPreviousPanorama() {
    _panoId.value = (_panoId.value - 1 + panoAssets.length) % panoAssets.length;
    if (kDebugMode) {
      print('Switched to panorama: ${_panoId.value}');
    }
  }

  // Toggle debug info
  void toggleDebugInfo() {
    _showDebugInfo.value = !_showDebugInfo.value;
  }

  // Show notify snackbar
  void showNotifySnack() {
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

  // Get brochure URL from storage
  String? getBrochureUrl() {
    try {
      final brochures = _storage.brochures;
      if (kDebugMode) {
        print('Fetched brochures from local storage: $brochures');
      }
      if (brochures != null && brochures.isNotEmpty) {
        final first = brochures.first;
        return first.imageUrl?.toString();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching brochures from local storage: $e');
      }
    }
    return null;
  }

  // Show siteplan modal
  void showSitePlanModal([String? url]) {
    // If caller didn't pass URL, try get from local storage
    if (url == null || url.isEmpty) {
      url = getBrochureUrl();
    }

    if (url == null || url.isEmpty) {
      Get.snackbar(
        'Site Plan',
        'Tidak ada URL brochure yang tersedia.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Debug log
    if (kDebugMode) {
      print('Opening Siteplan detail modal with url: $url');
    }

    // Navigate to SiteplanDetailPage
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

  // Get sensor control based on platform
  dynamic get sensorControl {
    // Import panorama_viewer package to get SensorControl enum
    // For now, return string that will be handled in view
    return isDesktop ? 'none' : 'orientation';
  }
}
