import 'package:dago_valley_explore/app/util/platform_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// Conditional import for window_manager (only on desktop)
import 'fullscreen_stub.dart'
    if (dart.library.io) 'fullscreen_io.dart' as fs_impl;

class FullscreenController extends GetxController {
  // Observable untuk track fullscreen state
  final RxBool _isFullscreen = false.obs;
  bool get isFullscreen => _isFullscreen.value;

  @override
  void onInit() {
    super.onInit();
    _checkFullscreenState();
  }

  // Cek state fullscreen saat init
  Future<void> _checkFullscreenState() async {
    if (PlatformHelper.isDesktop) {
      try {
        final isFullScreen = await fs_impl.isFullScreen();
        _isFullscreen.value = isFullScreen;
      } catch (e) {
        if (kDebugMode) print('Error checking fullscreen state: $e');
      }
    }
  }

  // Toggle fullscreen
  Future<void> toggleFullscreen() async {
    if (PlatformHelper.isDesktop) {
      try {
        final currentState = await fs_impl.isFullScreen();
        await fs_impl.setFullScreen(!currentState);
        _isFullscreen.value = !currentState;

        Get.snackbar(
          'Fullscreen',
          _isFullscreen.value ? 'Mode Fullscreen Aktif' : 'Mode Windowed Aktif',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        if (kDebugMode) print('Error toggling fullscreen: $e');
        Get.snackbar(
          'Error',
          'Gagal mengubah mode fullscreen',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (PlatformHelper.isWeb) {
      // On web, fullscreen could be implemented via dart:html in the future
      Get.snackbar(
        'Info',
        'Fullscreen: gunakan F11 di browser Anda',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Info',
        'Fullscreen hanya tersedia di Desktop',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Enter fullscreen
  Future<void> enterFullscreen() async {
    if (!_isFullscreen.value) {
      await toggleFullscreen();
    }
  }

  // Exit fullscreen
  Future<void> exitFullscreen() async {
    if (_isFullscreen.value) {
      await toggleFullscreen();
    }
  }
}
