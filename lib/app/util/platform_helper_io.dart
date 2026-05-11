import 'dart:io' show Platform, exit;

/// Native (non-web) implementation using dart:io Platform.

bool isDesktopPlatform() =>
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;

bool isWindowsPlatform() => Platform.isWindows;

bool isAndroidPlatform() => Platform.isAndroid;

bool isIOSPlatform() => Platform.isIOS;

void exitApplication() => exit(0);
