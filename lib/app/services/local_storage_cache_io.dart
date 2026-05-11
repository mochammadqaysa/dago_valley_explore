import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Helper to extract filename from URL
String _getFilenameFromUrl(String url) {
  final urlWithoutParams = url.split('?').first;
  String filename = urlWithoutParams.split('/').last;
  filename = filename.replaceAll(RegExp(r'[^\w\s\-\.]'), '_');
  return filename;
}

// ========== Video Cache ==========

Future<String> getCachedVideoPath(String url) async {
  final directory = await getApplicationSupportDirectory();
  final filename = _getFilenameFromUrl(url);
  return '${directory.path}/videos/$filename';
}

Future<File> saveVideoToLocal(String url, List<int> bytes) async {
  final directory = await getApplicationSupportDirectory();
  final videoDir = Directory('${directory.path}/videos');
  print('Video directory path: ${videoDir.path}');

  if (!await videoDir.exists()) {
    await videoDir.create(recursive: true);
    print('✅ Video directory created');
  }

  final filename = _getFilenameFromUrl(url);
  final file = File('${videoDir.path}/$filename');

  final savedFile = await file.writeAsBytes(bytes);
  final sizeMB = (bytes.length / 1024 / 1024).toStringAsFixed(2);
  print('✅ Video saved: ${file.path} ($sizeMB MB)');

  return savedFile;
}

Future<File?> getLocalVideo(String url) async {
  try {
    final path = await getCachedVideoPath(url);
    final file = File(path);
    if (await file.exists()) {
      final sizeMB = ((await file.length()) / 1024 / 1024).toStringAsFixed(2);
      print('✅ Video found in cache: ${file.path} ($sizeMB MB)');
      return file;
    }
  } catch (e) {
    print('❌ Error getting local video: $e');
  }
  return null;
}

Future<bool> isVideoCached(String url) async {
  final file = await getLocalVideo(url);
  return file != null;
}

Future<double> getVideosCacheSize() async {
  try {
    final directory = await getApplicationSupportDirectory();
    final videoDir = Directory('${directory.path}/videos');

    if (!await videoDir.exists()) {
      return 0.0;
    }

    int totalBytes = 0;
    await for (var entity in videoDir.list(recursive: true)) {
      if (entity is File) {
        totalBytes += await entity.length();
      }
    }

    return totalBytes / 1024 / 1024;
  } catch (e) {
    print('❌ Error calculating video cache size: $e');
    return 0.0;
  }
}

Future<void> clearVideoCache() async {
  try {
    final directory = await getApplicationSupportDirectory();
    final videoDir = Directory('${directory.path}/videos');

    if (await videoDir.exists()) {
      await videoDir.delete(recursive: true);
      print('✅ Video cache cleared');
    }
  } catch (e) {
    print('❌ Error clearing video cache: $e');
  }
}

Future<bool> deleteVideoFromCache(String url) async {
  try {
    final file = await getLocalVideo(url);
    if (file != null && await file.exists()) {
      await file.delete();
      print('✅ Video deleted from cache: $url');
      return true;
    }
    return false;
  } catch (e) {
    print('❌ Error deleting video from cache: $e');
    return false;
  }
}

// ========== Image Cache ==========

Future<String> getCachedImagePath(String url) async {
  final directory = await getApplicationSupportDirectory();
  final filename = _getFilenameFromUrl(url);
  return '${directory.path}/images/$filename';
}

Future<File> saveImageToLocal(String url, List<int> bytes) async {
  final directory = await getApplicationSupportDirectory();
  final imageDir = Directory('${directory.path}/images');
  print('Image directory path: ${imageDir.path}');

  if (!await imageDir.exists()) {
    await imageDir.create(recursive: true);
  }

  final filename = _getFilenameFromUrl(url);
  final file = File('${imageDir.path}/$filename');
  return await file.writeAsBytes(bytes);
}

Future<File?> getLocalImage(String url) async {
  try {
    final path = await getCachedImagePath(url);
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
  } catch (e) {
    print('Error getting local image: $e');
  }
  return null;
}

Future<bool> isImageCached(String url) async {
  final file = await getLocalImage(url);
  return file != null;
}

Future<double> getImagesCacheSize() async {
  try {
    final directory = await getApplicationSupportDirectory();
    final imageDir = Directory('${directory.path}/images');

    if (!await imageDir.exists()) {
      return 0.0;
    }

    int totalBytes = 0;
    await for (var entity in imageDir.list(recursive: true)) {
      if (entity is File) {
        totalBytes += await entity.length();
      }
    }

    return totalBytes / 1024 / 1024;
  } catch (e) {
    print('❌ Error calculating image cache size: $e');
    return 0.0;
  }
}

Future<void> clearImageCache() async {
  try {
    final directory = await getApplicationSupportDirectory();
    final imageDir = Directory('${directory.path}/images');

    if (await imageDir.exists()) {
      await imageDir.delete(recursive: true);
      print('✅ Image cache cleared');
    }
  } catch (e) {
    print('❌ Error clearing image cache: $e');
  }
}

// ========== Statistics ==========

Future<Map<String, dynamic>> getCacheStatistics() async {
  try {
    final directory = await getApplicationSupportDirectory();
    final imageDir = Directory('${directory.path}/images');
    final videoDir = Directory('${directory.path}/videos');

    int imageCount = 0;
    int videoCount = 0;
    int imageBytes = 0;
    int videoBytes = 0;

    if (await imageDir.exists()) {
      await for (var entity in imageDir.list()) {
        if (entity is File) {
          imageCount++;
          imageBytes += await entity.length();
        }
      }
    }

    if (await videoDir.exists()) {
      await for (var entity in videoDir.list()) {
        if (entity is File) {
          videoCount++;
          videoBytes += await entity.length();
        }
      }
    }

    return {
      'imageCount': imageCount,
      'videoCount': videoCount,
      'imageSizeMB': (imageBytes / 1024 / 1024),
      'videoSizeMB': (videoBytes / 1024 / 1024),
      'totalSizeMB': ((imageBytes + videoBytes) / 1024 / 1024),
    };
  } catch (e) {
    print('❌ Error getting cache statistics: $e');
    return {
      'imageCount': 0,
      'videoCount': 0,
      'imageSizeMB': 0.0,
      'videoSizeMB': 0.0,
      'totalSizeMB': 0.0,
    };
  }
}
