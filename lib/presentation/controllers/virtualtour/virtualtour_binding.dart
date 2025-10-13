import 'package:get/get.dart';
import '../../../domain/usecases/fetch_headline_use_case.dart';
import '../../../data/repositories/article_repository.dart';
import 'virtualtour_controller.dart';

class VirtualtourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetchHeadlineUseCase(Get.find<ArticleRepositoryIml>()));
    Get.lazyPut(() => VirtualtourController(Get.find()));
  }
}
