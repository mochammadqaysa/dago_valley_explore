/// Stub for web platform — file-based caching is not supported.

Future<String> getCachedVideoPath(String url) async => '';
Future<dynamic> saveVideoToLocal(String url, List<int> bytes) async => null;
Future<dynamic> getLocalVideo(String url) async => null;
Future<bool> isVideoCached(String url) async => false;
Future<double> getVideosCacheSize() async => 0.0;
Future<void> clearVideoCache() async {}
Future<bool> deleteVideoFromCache(String url) async => false;

Future<String> getCachedImagePath(String url) async => '';
Future<dynamic> saveImageToLocal(String url, List<int> bytes) async => null;
Future<dynamic> getLocalImage(String url) async => null;
Future<bool> isImageCached(String url) async => false;
Future<double> getImagesCacheSize() async => 0.0;
Future<void> clearImageCache() async {}

Future<Map<String, dynamic>> getCacheStatistics() async {
  return {
    'imageCount': 0,
    'videoCount': 0,
    'imageSizeMB': 0.0,
    'videoSizeMB': 0.0,
    'totalSizeMB': 0.0,
  };
}
