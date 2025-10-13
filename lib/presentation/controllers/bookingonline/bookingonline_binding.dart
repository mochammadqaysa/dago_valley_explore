import 'package:get/get.dart';
import '../../../domain/usecases/fetch_headline_use_case.dart';
import '../../../data/repositories/article_repository.dart';
import 'bookingonline_controller.dart';

class BookingonlineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetchHeadlineUseCase(Get.find<ArticleRepositoryIml>()));
    Get.lazyPut(() => BookingonlineController(Get.find()));
  }
}
