import 'package:dago_valley_explore/presentation/controllers/locale/locale_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';

class DependencyCreator {
  static init() {
    // Inject ThemeController sebagai permanent dependency
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<LocaleController>(LocaleController(), permanent: true);
    print('ThemeController injected');
    Get.lazyPut(() => AuthenticationRepositoryIml());
    // Get.lazyPut(() => ArticleRepositoryIml());
  }
}
