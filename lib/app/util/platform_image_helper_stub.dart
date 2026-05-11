import 'package:flutter/material.dart';

/// Stub for web: File operations are not supported.

bool fileExists(dynamic file) => false;

Widget buildFileImage(
  dynamic file, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  bool gaplessPlayback = false,
}) {
  // Should never be called on web
  return const SizedBox.shrink();
}
