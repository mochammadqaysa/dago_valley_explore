import 'dart:typed_data';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/payload/housing_response.dart';
import 'package:dago_valley_explore/domain/usecases/fetch_housing_use_case.dart';
import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_binding.dart';
import 'package:dago_valley_explore/presentation/pages/home/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
    print('🎬 SplashController initialized');
    initializeApp();
  }

  @override
  void onClose() {
    print('🛑 SplashController closed');
    super.onClose();
  }

  Future<void> initializeApp() async {
    try {
      print('🚀 Starting app initialization...');
      isLoading.value = true;
      errorMessage.value = '';

      // Minimum splash duration 2 detik
      await Future.wait([
        loadHousingData(),
        Future.delayed(const Duration(seconds: 2)),
      ]);

      await Future.delayed(const Duration(milliseconds: 500));

      print('✅ Initialization complete, navigating to HomePage');
      Get.off(() => HomePage(), binding: SidebarBinding());
    } catch (e, stackTrace) {
      print('❌ Error initializing app: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
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
      final localKprCalculators = _storage.kprCalculators;
      final localVersions = _storage.versions;

      print('📦 Local data check:');
      print('- Promos: ${localPromos?.length ?? 0}');
      print('- Events: ${localEvents?.length ?? 0}');
      print('- KPR Calculators: ${localKprCalculators?.length ?? 0}');
      print('- Versions: ${localVersions?.toJson()}');

      // Fetch data dari API menggunakan use case
      loadingMessage.value = 'Mengunduh data terbaru...';
      final response = await _fetchHousingDataUseCase.execute();

      if (response.housing.isNotEmpty) {
        final apiVersions = response.version;
        final housing = response.housing.first;

        print('🌐 API data check:');
        print('- Housing: ${housing ?? 0}');
        print('- Promos: ${housing.promos?.length ?? 0}');
        print('- Events: ${housing.events?.length ?? 0}');
        print('- KPR Calculators: ${housing.kprCalculators?.length ?? 0}');
        print('- Versions: ${apiVersions.toJson()}');

        // Cek apakah perlu update
        final needsUpdate = _checkNeedsUpdate(localVersions, apiVersions);

        if (needsUpdate) {
          loadingMessage.value = 'Menyimpan data baru...';
          print('🔄 Updating local data...');

          // Simpan housing
          _storage.housings = housing;
          print('✅ Saved housing');

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

          // Simpan siteplan
          if (housing.siteplans != null && housing.siteplans!.isNotEmpty) {
            _storage.siteplans = housing.siteplans!;
            print('✅ Saved ${housing.siteplans!.length} events');

            // Download dan simpan gambar event
            await _downloadImages(
              housing.siteplans!.map((e) => e.imageUrl).toList(),
            );
            await _downloadImages(
              housing.siteplans!.map((e) => e.mapUrl).toList(),
            );
            await _downloadImages(
              housing.siteplans!.map((e) => e.fasumUrl).toList(),
            );
            await _downloadImages(
              housing.siteplans!.map((e) => e.timelineProgressUrl).toList(),
            );
          }

          // simpan brosur
          if (housing.brochures != null && housing.brochures!.isNotEmpty) {
            _storage.brochures = housing.brochures!;
            print('✅ Saved ${housing.brochures!.length} brochures');
          }

          // Simpan kpr calculators
          if (housing.kprCalculators != null &&
              housing.kprCalculators!.isNotEmpty) {
            _storage.kprCalculators = housing.kprCalculators!;
            print('✅ Saved ${housing.kprCalculators!.length} kpr calculators');
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
      final localKprCalculators = _storage.kprCalculators;

      if (localPromos != null ||
          localEvents != null ||
          localKprCalculators != null) {
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

    if (apiVersions.kprCalculatorVersion != null &&
        apiVersions.kprCalculatorVersion !=
            localVersions.kprCalculatorVersion) {
      print(
        '🔄 KPR Calculator version changed: ${localVersions.kprCalculatorVersion} -> ${apiVersions.kprCalculatorVersion}',
      );
      return true;
    }

    return false;
  }

  Future<void> _downloadImages(List<String> imageUrls) async {
    loadingMessage.value = 'Mengunduh gambar...';

    final client = http.Client();
    try {
      for (final imageUrl in imageUrls) {
        if (imageUrl.isEmpty || imageUrl.startsWith('assets/')) continue;

        try {
          final existing = await _storage.getLocalImage(imageUrl);
          if (existing != null) {
            print('✅ Image already cached: $imageUrl');
            continue;
          }

          print('⬇️ Downloading image: $imageUrl');
          final uri = Uri.parse(imageUrl);
          final response = await client
              .get(
                uri,
                headers: {
                  // Jika server memerlukan user-agent
                  'User-Agent': 'Mozilla/5.0 (Windows NT) FlutterApp',
                  'Accept': 'image/*',
                },
              )
              .timeout(const Duration(seconds: 20));

          print(
            'Response statusCode: ${response.statusCode}, bytes: ${response.bodyBytes.length}',
          );

          if (response.statusCode == 200) {
            final bytes = response.bodyBytes;
            await _storage.saveImageToLocal(imageUrl, bytes);
            print('✅ Image saved: $imageUrl');
          } else {
            print(
              '❌ Failed to download image ($imageUrl) status: ${response.statusCode}',
            );
          }
        } catch (e) {
          print('❌ Error downloading image $imageUrl: $e');
        }
      }
    } finally {
      client.close();
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
    print('🔄 Retrying initialization...');
    await initializeApp();
  }
}
