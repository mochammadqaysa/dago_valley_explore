/// Stub implementation for web platform where dart:io is not available.
/// These functions should never actually be called on web because
/// PlatformHelper guards them with kIsWeb checks.

bool isDesktopPlatform() => false;

bool isWindowsPlatform() => false;

bool isAndroidPlatform() => false;

bool isIOSPlatform() => false;

void exitApplication() {
  // No-op on web; PlatformHelper.exitApp() handles web case separately
}
