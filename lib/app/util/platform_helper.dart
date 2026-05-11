import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

// Conditional import: use stub on web, real dart:io on native
import 'platform_helper_stub.dart'
    if (dart.library.io) 'platform_helper_io.dart' as platform_impl;

/// Platform-agnostic helper that works on both Web and native (desktop/mobile).
/// Replaces direct usage of `dart:io` Platform checks throughout the app.
class PlatformHelper {
  PlatformHelper._();

  /// Whether the app is running on the web.
  static bool get isWeb => kIsWeb;

  /// Whether the app is running on a desktop platform (Windows, macOS, Linux).
  /// Always false on web.
  static bool get isDesktop {
    if (kIsWeb) return false;
    return platform_impl.isDesktopPlatform();
  }

  /// Whether the app is running on Windows.
  /// Always false on web.
  static bool get isWindows {
    if (kIsWeb) return false;
    return platform_impl.isWindowsPlatform();
  }

  /// Whether the app is running on Android.
  /// Always false on web.
  static bool get isAndroid {
    if (kIsWeb) return false;
    return platform_impl.isAndroidPlatform();
  }

  /// Whether the app is running on iOS.
  /// Always false on web.
  static bool get isIOS {
    if (kIsWeb) return false;
    return platform_impl.isIOSPlatform();
  }

  /// Exit the application gracefully.
  /// On web: uses SystemNavigator.pop() (may close tab in some browsers).
  /// On desktop/mobile: uses dart:io exit(0).
  static void exitApp() {
    if (kIsWeb) {
      SystemNavigator.pop();
    } else {
      platform_impl.exitApplication();
    }
  }
}
