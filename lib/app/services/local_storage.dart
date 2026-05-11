import 'dart:convert';
import 'package:dago_valley_explore/domain/entities/brochure.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';
import 'package:dago_valley_explore/domain/entities/housing.dart';
import 'package:dago_valley_explore/domain/entities/kpr_calculator.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:dago_valley_explore/domain/entities/site_plan.dart';
import 'package:dago_valley_explore/domain/entities/version.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import for file-based caching (only native)
import 'local_storage_cache_stub.dart'
    if (dart.library.io) 'local_storage_cache_io.dart' as cache_impl;

enum _Key {
  user,
  promos,
  housing,
  events,
  siteplans,
  kprCalculators,
  brochures,
  versions,
  lastUpdate,
}

class LocalStorageService extends GetxService {
  SharedPreferences? _sharedPreferences;

  Future<LocalStorageService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  // ========== User Management ==========
  User? get user {
    final rawJson = _sharedPreferences?.getString(_Key.user.toString());
    if (rawJson == null) return null;
    Map<String, dynamic> map = jsonDecode(rawJson);
    return User.fromJson(map);
  }

  set user(User? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.user.toString(),
        json.encode(value.toJson()),
      );
    } else {
      _sharedPreferences?.remove(_Key.user.toString());
    }
  }

  // ========== Housing Management ==========
  Housing? get housings {
    final rawJson = _sharedPreferences?.getString(_Key.housing.toString());
    if (rawJson == null) return null;

    try {
      Map<String, dynamic> list = jsonDecode(rawJson);
      return Housing.fromJson(list);
    } catch (e) {
      print('Error parsing housings: $e');
      return null;
    }
  }

  set housings(Housing? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.housing.toString(),
        json.encode(value.toJson()),
      );
    } else {
      _sharedPreferences?.remove(_Key.housing.toString());
    }
  }

  // ========== Promo Management ==========
  List<Promo>? get promos {
    final rawJson = _sharedPreferences?.getString(_Key.promos.toString());
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => Promo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing promos: $e');
      return null;
    }
  }

  set promos(List<Promo>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.promos.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.promos.toString());
    }
  }

  // ========== Event Management ==========
  List<Event>? get events {
    final rawJson = _sharedPreferences?.getString(_Key.events.toString());
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing events: $e');
      return null;
    }
  }

  set events(List<Event>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.events.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.events.toString());
    }
  }

  // ========== Siteplan Management ==========
  List<SitePlan>? get siteplans {
    final rawJson = _sharedPreferences?.getString(_Key.siteplans.toString());
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => SitePlan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing events: $e');
      return null;
    }
  }

  set siteplans(List<SitePlan>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.siteplans.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.siteplans.toString());
    }
  }

  // ========== KPR Calculator Management ==========
  List<KprCalculator>? get kprCalculators {
    final rawJson = _sharedPreferences?.getString(
      _Key.kprCalculators.toString(),
    );
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => KprCalculator.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing kpr calculators: $e');
      return null;
    }
  }

  set kprCalculators(List<KprCalculator>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.kprCalculators.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.kprCalculators.toString());
    }
  }

  // ========== Brochure Management ==========
  List<Brochure>? get brochures {
    final rawJson = _sharedPreferences?.getString(_Key.brochures.toString());
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => Brochure.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing brochures: $e');
      return null;
    }
  }

  set brochures(List<Brochure>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.brochures.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.events.toString());
    }
  }

  // ========== Version Management ==========
  Version? get versions {
    final rawJson = _sharedPreferences?.getString(_Key.versions.toString());
    if (rawJson == null) return null;

    try {
      Map<String, dynamic> map = jsonDecode(rawJson);
      return Version.fromJson(map);
    } catch (e) {
      print('Error parsing versions: $e');
      return null;
    }
  }

  set versions(Version? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.versions.toString(),
        json.encode(value.toJson()),
      );
    } else {
      _sharedPreferences?.remove(_Key.versions.toString());
    }
  }

  // ========== Last Update Timestamp ==========
  DateTime? get lastUpdate {
    final timestamp = _sharedPreferences?.getInt(_Key.lastUpdate.toString());
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  set lastUpdate(DateTime? value) {
    if (value != null) {
      _sharedPreferences?.setInt(
        _Key.lastUpdate.toString(),
        value.millisecondsSinceEpoch,
      );
    } else {
      _sharedPreferences?.remove(_Key.lastUpdate.toString());
    }
  }

  // ========== Video Cache Management ==========
  // On web, file-based caching is not supported; these return null/empty/no-op.

  /// Get cached video file path
  Future<String> getCachedVideoPath(String url) async {
    if (kIsWeb) return '';
    return cache_impl.getCachedVideoPath(url);
  }

  /// Save video to local storage
  /// Returns the file on native, null on web.
  Future<dynamic> saveVideoToLocal(String url, List<int> bytes) async {
    if (kIsWeb) return null;
    return cache_impl.saveVideoToLocal(url, bytes);
  }

  /// Get local video file if exists (returns File? on native, null on web)
  Future<dynamic> getLocalVideo(String url) async {
    if (kIsWeb) return null;
    return cache_impl.getLocalVideo(url);
  }

  /// Check if video exists in cache
  Future<bool> isVideoCached(String url) async {
    if (kIsWeb) return false;
    return cache_impl.isVideoCached(url);
  }

  /// Get total size of cached videos in MB
  Future<double> getVideosCacheSize() async {
    if (kIsWeb) return 0.0;
    return cache_impl.getVideosCacheSize();
  }

  /// Clear video cache
  Future<void> clearVideoCache() async {
    if (kIsWeb) return;
    return cache_impl.clearVideoCache();
  }

  /// Delete specific video from cache
  Future<bool> deleteVideoFromCache(String url) async {
    if (kIsWeb) return false;
    return cache_impl.deleteVideoFromCache(url);
  }

  // ========== Image Cache Management ==========

  Future<String> getCachedImagePath(String url) async {
    if (kIsWeb) return '';
    return cache_impl.getCachedImagePath(url);
  }

  Future<dynamic> saveImageToLocal(String url, List<int> bytes) async {
    if (kIsWeb) return null;
    return cache_impl.saveImageToLocal(url, bytes);
  }

  Future<dynamic> getLocalImage(String url) async {
    if (kIsWeb) return null;
    return cache_impl.getLocalImage(url);
  }

  /// Check if image exists in cache
  Future<bool> isImageCached(String url) async {
    if (kIsWeb) return false;
    return cache_impl.isImageCached(url);
  }

  /// Get total size of cached images in MB
  Future<double> getImagesCacheSize() async {
    if (kIsWeb) return 0.0;
    return cache_impl.getImagesCacheSize();
  }

  /// Clear image cache
  Future<void> clearImageCache() async {
    if (kIsWeb) return;
    return cache_impl.clearImageCache();
  }

  // ========== Helper Methods ==========

  /// Extract filename from URL, handling query parameters and special characters
  String getFilenameFromUrl(String url) {
    // Remove query parameters
    final urlWithoutParams = url.split('?').first;

    // Get filename
    String filename = urlWithoutParams.split('/').last;

    // Sanitize filename (remove special characters except dots and dashes)
    filename = filename.replaceAll(RegExp(r'[^\w\s\-\.]'), '_');

    return filename;
  }

  /// Get total cache size (images + videos) in MB
  Future<double> getTotalCacheSize() async {
    final imageSize = await getImagesCacheSize();
    final videoSize = await getVideosCacheSize();
    return imageSize + videoSize;
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    if (kIsWeb) {
      return {
        'imageCount': 0,
        'videoCount': 0,
        'imageSizeMB': 0.0,
        'videoSizeMB': 0.0,
        'totalSizeMB': 0.0,
      };
    }
    return cache_impl.getCacheStatistics();
  }

  // ========== Clear All Cache ==========

  Future<void> clearCache() async {
    // Clear SharedPreferences data
    promos = null;
    events = null;
    kprCalculators = null;
    versions = null;
    lastUpdate = null;

    // Clear image cache
    await clearImageCache();

    // Clear video cache
    await clearVideoCache();

    print('✅ All cache cleared');
  }
}
