import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

/// Desktop-specific initialization: window manager setup.
Future<void> initDesktopWindow() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(3840, 2160),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setFullScreen(true);
  });
}

/// Desktop-specific error logging to file.
void logError(String msg) async {
  try {
    final dir = await getApplicationSupportDirectory();
    final logFile = File('${dir.path}/startup_error.log');
    await logFile.writeAsString(msg, mode: FileMode.append);
  } catch (_) {
    // Silently ignore if logging fails
  }
}
