import 'dart:typed_data';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/payload/housing_response.dart';
import 'package:dago_valley_explore/domain/usecases/fetch_housing_use_case.dart';
import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_binding.dart';
import 'package:dago_valley_explore/presentation/pages/home/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  SplashController(this._fetchHousingDataUseCase);

  final FetchHousingDataUseCase _fetchHousingDataUseCase;
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final loadingMessage = 'Memuat data...'.obs;
  final housingData = Rx<HousingResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Minimum splash duration 2 detik
      await Future.wait([
        loadHousingData(),
        Future.delayed(const Duration(seconds: 2)),
      ]);

      await Future.delayed(const Duration(milliseconds: 500));
      Get.off(() => HomePage(), binding: SidebarBinding());
    } catch (e) {
      print('❌ Error initializing app: $e');
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHousingData() async {
    try {
      loadingMessage.value = 'Memeriksa pembaruan...';

      // Ambil data lokal
      final localPromos = _storage.promos;
      final localEvents = _storage.events;
      final localVersions = _storage.versions;

      print('📦 Local data check:');
      print('- Promos: ${localPromos?.length ?? 0}');
      print('- Events: ${localEvents?.length ?? 0}');
      print('- Versions: ${localVersions?.toJson()}');

      // Fetch data dari API menggunakan use case
      loadingMessage.value = 'Mengunduh data terbaru...';
      final response = await _fetchHousingDataUseCase.execute();

      if (response.housing.isNotEmpty) {
        final apiVersions = response.version;
        final housing = response.housing.first;

        print('🌐 API data check:');
        print('- Promos: ${housing.promos?.length ?? 0}');
        print('- Events: ${housing.events?.length ?? 0}');
        print('- Versions: ${apiVersions.toJson()}');

        // Cek apakah perlu update
        final needsUpdate = _checkNeedsUpdate(localVersions, apiVersions);

        if (needsUpdate) {
          loadingMessage.value = 'Menyimpan data baru...';
          print('🔄 Updating local data...');

          // Simpan promo
          if (housing.promos != null && housing.promos!.isNotEmpty) {
            _storage.promos = housing.promos!;
            print('✅ Saved ${housing.promos!.length} promos');

            // Download dan simpan gambar promo
            await _downloadImages(
              housing.promos!.map((e) => e.imageUrl).toList(),
            );
          }

          // Simpan event
          if (housing.events != null && housing.events!.isNotEmpty) {
            _storage.events = housing.events!;
            print('✅ Saved ${housing.events!.length} events');

            // Download dan simpan gambar event
            await _downloadImages(
              housing.events!.map((e) => e.imageUrl).toList(),
            );
          }

          // Simpan version
          _storage.versions = apiVersions;
          print('✅ Saved versions: ${apiVersions.toJson()}');

          // Update last update timestamp
          _storage.lastUpdate = DateTime.now();

          housingData.value = response;
          print('✅ Data updated successfully');
        } else {
          print('✅ Data is up to date, using cached data');
          loadingMessage.value = 'Menggunakan data lokal...';
        }
      } else {
        throw Exception('Data housing kosong dari API');
      }
    } catch (e, stackTrace) {
      print('❌ Error loading housing data: $e');
      print('Stack trace: ${stackTrace}');

      // Cek apakah ada data lokal sebagai fallback
      final localPromos = _storage.promos;
      final localEvents = _storage.events;

      if (localPromos != null || localEvents != null) {
        print('💾 Using local cache as fallback');
        loadingMessage.value = 'Menggunakan data tersimpan...';
      } else {
        rethrow;
      }
    }
  }

  bool _checkNeedsUpdate(dynamic localVersions, dynamic apiVersions) {
    if (localVersions == null || apiVersions == null) {
      print('⚠️ No local version or API version, forcing update');
      return true;
    }

    // Cek version promo
    if (apiVersions.promoVersion != null &&
        apiVersions.promoVersion != localVersions.promoVersion) {
      print(
        '🔄 Promo version changed: ${localVersions.promoVersion} -> ${apiVersions.promoVersion}',
      );
      return true;
    }

    // Cek version event
    if (apiVersions.eventVersion != null &&
        apiVersions.eventVersion != localVersions.eventVersion) {
      print(
        '🔄 Event version changed: ${localVersions.eventVersion} -> ${apiVersions.eventVersion}',
      );
      return true;
    }

    return false;
  }

  Future<void> _downloadImages(List<String> imageUrls) async {
    loadingMessage.value = 'Mengunduh gambar...';

    for (var imageUrl in imageUrls) {
      // Skip jika URL kosong atau dari assets
      if (imageUrl.isEmpty || imageUrl.startsWith('assets/')) continue;

      try {
        // Cek apakah gambar sudah ada di lokal
        final localImage = await _storage.getLocalImage(imageUrl);
        if (localImage != null) {
          print('✅ Image already cached: $imageUrl');
          continue;
        }

        // Download gambar menggunakan GetConnect
        print('⬇️ Downloading image: $imageUrl');
        final response = await GetConnect().get(imageUrl);

        if (response.statusCode == 200 && response.bodyBytes != null) {
          // Convert Stream<List<int>> ke Uint8List
          final bytes = await _streamToBytes(response.bodyBytes!);
          await _storage.saveImageToLocal(imageUrl, bytes);
          print('✅ Image saved: $imageUrl');
        }
      } catch (e) {
        print('❌ Error downloading image $imageUrl: $e');
        // Continue dengan gambar lain meski ada yang gagal
      }
    }
  }

  // Helper method untuk convert Stream<List<int>> ke Uint8List
  Future<Uint8List> _streamToBytes(Stream<List<int>> stream) async {
    final List<int> bytes = [];
    await for (final chunk in stream) {
      bytes.addAll(chunk);
    }
    return Uint8List.fromList(bytes);
  }

  Future<void> retry() async {
    await initializeApp();
  }
}
