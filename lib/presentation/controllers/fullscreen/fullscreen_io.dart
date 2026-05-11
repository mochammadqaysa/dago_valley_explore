import 'package:window_manager/window_manager.dart';

/// Native desktop implementation using window_manager.

Future<bool> isFullScreen() async {
  return await windowManager.isFullScreen();
}

Future<void> setFullScreen(bool fullscreen) async {
  await windowManager.setFullScreen(fullscreen);
}
