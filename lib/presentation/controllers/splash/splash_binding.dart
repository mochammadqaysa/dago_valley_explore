import 'package:dago_valley_explore/data/repositories/house_repository.dart';
import 'package:dago_valley_explore/domain/repositories/house_repository.dart';
import 'package:dago_valley_explore/domain/usecases/fetch_housing_use_case.dart';
import 'package:dago_valley_explore/presentation/controllers/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Repository (jika belum ada di DependencyCreator)
    Get.lazyPut<HouseRepository>(() => HouseRepositoryImpl());

    // UseCase
    Get.lazyPut(() => FetchHousingDataUseCase(Get.find<HouseRepository>()));

    // Controller
    Get.lazyPut(() => SplashController(Get.find<FetchHousingDataUseCase>()));
  }
}
