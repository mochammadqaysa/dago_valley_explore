/// Stub for web — window_manager fullscreen is not available.

Future<bool> isFullScreen() async => false;

Future<void> setFullScreen(bool fullscreen) async {
  // No-op on web
}
