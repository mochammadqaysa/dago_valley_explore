import 'package:get/get.dart';
import '../../../domain/usecases/fetch_headline_use_case.dart';
import '../../../data/repositories/article_repository.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FetchHeadlineUseCase(Get.find<ArticleRepositoryIml>()));
    Get.lazyPut(() => DashboardController(Get.find()));
  }
}
