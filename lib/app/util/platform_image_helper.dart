import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import for File operations
import 'platform_image_helper_stub.dart'
    if (dart.library.io) 'platform_image_helper_io.dart' as img_impl;

import 'package:flutter/material.dart';

/// Builds an image widget that first attempts to load from a cached [file]
/// (on desktop/mobile), falling back to [assetPath] or [networkUrl].
///
/// On web, local file caching is skipped entirely — the widget goes straight
/// to the asset or network fallback.
Widget buildCachedImage({
  dynamic file, // File? on native, null on web
  String? assetPath,
  String? networkUrl,
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  bool gaplessPlayback = false,
}) {
  // On native, try local file first
  if (!kIsWeb && file != null && img_impl.fileExists(file)) {
    return img_impl.buildFileImage(
      file,
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: gaplessPlayback,
    );
  }

  // Fallback to network URL
  if (networkUrl != null && networkUrl.isNotEmpty) {
    return Image.network(
      networkUrl,
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: gaplessPlayback,
      errorBuilder: (context, error, stackTrace) {
        if (assetPath != null) {
          return Image.asset(
            assetPath,
            fit: fit,
            width: width,
            height: height,
            gaplessPlayback: gaplessPlayback,
          );
        }
        return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
      },
    );
  }

  // Fallback to asset
  if (assetPath != null) {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: gaplessPlayback,
    );
  }

  return const Icon(Icons.image_not_supported, size: 48, color: Colors.grey);
}
