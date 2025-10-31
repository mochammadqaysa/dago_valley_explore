import 'dart:convert';

import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Key { user, promos, events, versions, lastUpdate }

class LocalStorageService extends GetxService {
  SharedPreferences? _sharedPreferences;

  Future<LocalStorageService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  // User Management
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

  // Promo Management
  List<Promo>? get promos {
    final rawJson = _sharedPreferences?.getString(_Key.promos.toString());
    if (rawJson == null) return null;
    List<dynamic> list = jsonDecode(rawJson);
    return list.map((e) => Promo.fromJson(e as Map<String, dynamic>)).toList();
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

  // Event Management
  List<Promo>? get events {
    final rawJson = _sharedPreferences?.getString(_Key.events.toString());
    if (rawJson == null) return null;
    List<dynamic> list = jsonDecode(rawJson);
    return list.map((e) => Promo.fromJson(e as Map<String, dynamic>)).toList();
  }

  set events(List<Promo>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.events.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.events.toString());
    }
  }

  // Version Management
  HousingVersion? get versions {
    final rawJson = _sharedPreferences?.getString(_Key.versions.toString());
    if (rawJson == null) return null;
    Map<String, dynamic> map = jsonDecode(rawJson);
    return HousingVersion.fromJson(map);
  }

  set versions(HousingVersion? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.versions.toString(),
        json.encode(value.toJson()),
      );
    } else {
      _sharedPreferences?.remove(_Key.versions.toString());
    }
  }

  // Last Update Timestamp
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

  // Image Cache Management
  Future<String> getCachedImagePath(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filename = url.split('/').last;
    return '${directory.path}/images/$filename';
  }

  Future<File> saveImageToLocal(String url, List<int> bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final filename = url.split('/').last;
    final file = File('${imageDir.path}/$filename');
    return await file.writeAsBytes(bytes);
  }

  Future<File?> getLocalImage(String url) async {
    final path = await getCachedImagePath(url);
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  // Clear all cached data
  Future<void> clearCache() async {
    promos = null;
    events = null;
    versions = null;
    lastUpdate = null;

    // Clear image cache
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/images');
    if (await imageDir.exists()) {
      await imageDir.delete(recursive: true);
    }
  }
}
