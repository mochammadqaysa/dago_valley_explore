import 'package:get/get.dart';

class QRCodeController extends GetxController {
  // URL untuk Google Search "Dago Valley"
  final searchUrl = 'https://share.google/X2hw1barxPYD8QBjy';

  // Observable untuk loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    print('QRCodeController initialized');
  }

  @override
  void onClose() {
    print('QRCodeController disposed');
    super.onClose();
  }

  // Close modal
  void closeModal() {
    Get.back();
  }

  // Handle download QR (opsional)
  void downloadQR() {
    Get.snackbar(
      'Download QR',
      'QR Code berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Tambahkan logic download di sini
  }

  // Handle share QR (opsional)
  void shareQR() {
    Get.snackbar(
      'Share QR',
      'Sharing QR Code...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Tambahkan logic share di sini
  }

  // Copy link to clipboard
  void copyLink() {
    // Tambahkan clipboard copy logic
    Get.snackbar(
      'Link Copied',
      'Link berhasil disalin ke clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
