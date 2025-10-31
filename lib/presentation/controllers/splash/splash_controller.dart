import 'package:dago_valley_explore/presentation/pages/home/home_page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  // final HousingApiService _apiService = Get.put(HousingApiService());

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  // final Rx<HousingDataResponse?> housingData = Rx<HousingDataResponse?>(null);

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
        // loadHousingData(),
        Future.delayed(const Duration(seconds: 2)),
      ]);

      await Future.delayed(const Duration(milliseconds: 500));
      Get.off(HomePage());
      // if (true) {
      //   // Navigate to home after success
      // } else {
      //   errorMessage.value = 'Gagal memuat data';
      // }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> loadHousingData() async {
  //   try {
  //     final data = await _apiService.getHousingData();
  //     if (data != null) {
  //       housingData.value = data;

  //       // Simpan data ke GetStorage atau SharedPreferences jika perlu
  //       // await _saveDataLocally(data);

  //       print('Data loaded successfully: ${data.housing.length} housing found');
  //     }
  //   } catch (e) {
  //     print('Error loading housing data: $e');
  //     rethrow;
  //   }
  // }

  Future<void> retry() async {
    await initializeApp();
  }
}
