import 'dart:io' show File;
import 'package:flutter/material.dart';

/// Native implementation: uses dart:io File for image loading.

bool fileExists(dynamic file) {
  if (file is File) {
    return file.existsSync();
  }
  return false;
}

Widget buildFileImage(
  dynamic file, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  bool gaplessPlayback = false,
}) {
  return Image.file(
    file as File,
    fit: fit,
    width: width,
    height: height,
    gaplessPlayback: gaplessPlayback,
  );
}
