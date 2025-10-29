import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SplashController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';
    try {
      final response = await http.get(
        Uri.parse('https://housing.qaanii.com/api/v2/data'),
      );
      if (response.statusCode == 200) {
        // final data = response.body; // simpan jika perlu
        isLoading.value = false;
        isError.value = false;
        // TODO: simpan data ke storage jika dibutuhkan
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAllNamed('/home');
        });
      } else {
        isError.value = true;
        errorMessage.value =
            'Gagal memuat data (status: ${response.statusCode})';
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Gagal terhubung ke server. $e';
    } finally {
      isLoading.value = false;
    }
  }
}
