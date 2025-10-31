import 'package:get/get.dart';
import '../../../domain/usecases/fetch_headline_use_case.dart';
import 'cashcalculator_controller.dart';

class CashcalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CashcalculatorController());
  }
}
