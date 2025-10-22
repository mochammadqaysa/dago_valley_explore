import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/home/home_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    final themeController = Get.put(ThemeController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dago Valley Explore',

        // Theme configuration
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,

        initialRoute: "/",
        initialBinding: SidebarBinding(),
        home: HomePage(),
      ),
    );
  }
}
