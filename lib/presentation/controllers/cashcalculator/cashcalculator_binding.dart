import 'package:get/get.dart';
import '../../../domain/usecases/fetch_headline_use_case.dart';
import '../../../data/repositories/article_repository.dart';
import 'cashcalculator_controller.dart';

class CashcalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetchHeadlineUseCase(Get.find<ArticleRepositoryIml>()));
    Get.lazyPut(() => CashcalculatorController(Get.find()));
  }
}
