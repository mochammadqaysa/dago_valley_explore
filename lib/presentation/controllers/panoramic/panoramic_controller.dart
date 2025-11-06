import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PanoramicController extends GetxController {
  PanoramicController();

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
    Image.asset('assets/walkthrough/panorama_1.jpg', fit: BoxFit.cover),
    Image.asset('assets/walkthrough/panorama_2.jpg', fit: BoxFit.cover),
    Image.asset('assets/walkthrough/panorama_3.jpg', fit: BoxFit.cover),
  ];

  // Get current panorama asset
  Image get currentPanoAsset => panoAssets[_panoId.value % panoAssets.length];

  // Check if running on desktop
  bool get isDesktop {
    return !kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  }

  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Observable untuk list promo
  final _promos = RxList<Promo>([]);
  List<Promo> get promos => _promos;

  // Loading states untuk setiap image
  final _imageLoadingStates = <String, Rx<bool>>{}.obs;
  final _imageFiles = <String, Rx<File?>>{}.obs;

  // Current promo
  Promo get currentPromo {
    if (_promos.isEmpty) {
      return dummyPromos.first;
    }
    return _promos[_currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    loadPromos();
    preloadAllImages();
    _initializePanorama();
  }

  void _initializePanorama() {
    if (kDebugMode) {
      print('Initializing Siteplan Panorama');
    }
  }

  @override
  void onClose() {
    super.onClose();
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

  void loadPromos() {
    final cachedPromos = _storage.promos;
    if (cachedPromos != null && cachedPromos.isNotEmpty) {
      print('✅ Using cached promos: ${cachedPromos.length} items');
      _promos.assignAll(cachedPromos);
    } else {
      print('⚠️ Using dummy promos');
      _promos.assignAll(dummyPromos);
    }
  }

  // Preload all images
  Future<void> preloadAllImages() async {
    for (var promo in _promos) {
      await getLocalImage(promo.imageUrl);
    }
  }

  // Get local image file
  Future<File?> getLocalImage(String imageUrl) async {
    if (imageUrl.isEmpty) return null;

    // Initialize loading state if not exists
    if (!_imageLoadingStates.containsKey(imageUrl)) {
      _imageLoadingStates[imageUrl] = true.obs;
      _imageFiles[imageUrl] = Rx<File?>(null);
    }

    try {
      final file = await _storage.getLocalImage(imageUrl);
      _imageFiles[imageUrl]?.value = file;
      _imageLoadingStates[imageUrl]?.value = false;
      return file;
    } catch (e) {
      print('Error loading image: $e');
      _imageLoadingStates[imageUrl]?.value = false;
      return null;
    }
  }

  // Check if image is loading
  bool isImageLoading(String imageUrl) {
    return _imageLoadingStates[imageUrl]?.value ?? true;
  }

  // Get cached image file
  File? getCachedImageFile(String imageUrl) {
    return _imageFiles[imageUrl]?.value;
  }

  // Set index carousel
  void setCurrentIndex(int index) {
    _currentIndex.value = index;
  }

  // Go to specific page
  void goToPage(int index) {
    carouselController.animateToPage(index);
  }

  // Handle booking action
  void bookPromo() {
    Get.snackbar(
      'Booking',
      'Booking promo: ${currentPromo.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Close modal
  void closeModal() {
    Get.back();
  }

  // Helper method to check if file exists
  bool fileExists(File? file) {
    return file != null && file.existsSync();
  }
}
