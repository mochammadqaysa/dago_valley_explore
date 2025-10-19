import 'package:dago_valley_explore/presentation/controllers/promo/promo_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_controller.dart';
import 'package:get/get.dart';

class QrCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QRCodeController>(() => QRCodeController());
  }
}
