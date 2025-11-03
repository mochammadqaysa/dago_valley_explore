import 'dart:convert';
import 'dart:io';
import 'package:dago_valley_explore/domain/entities/brochure.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';
import 'package:dago_valley_explore/domain/entities/kpr_calculator.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:dago_valley_explore/domain/entities/site_plan.dart';
import 'package:dago_valley_explore/domain/entities/version.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Key {
  user,
  promos,
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

  // ========== Image Cache Management ==========
  Future<String> getCachedImagePath(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filename = url.split('/').last;
    return '${directory.path}/images/$filename';
  }

  Future<File> saveImageToLocal(String url, List<int> bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/images');
    print('Image directory path: ${imageDir.path}');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final filename = url.split('/').last;
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

  // ========== Clear Cache ==========
  Future<void> clearCache() async {
    promos = null;
    events = null;
    kprCalculators = null;
    versions = null;
    lastUpdate = null;

    // Clear image cache
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${directory.path}/images');
      if (await imageDir.exists()) {
        await imageDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing image cache: $e');
    }
  }
}
