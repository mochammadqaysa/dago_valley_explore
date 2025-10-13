import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth/auth_binding.dart';
import 'pages/home/home_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      // initialBinding: AuthBinding(),
      home: HomePage(),
    );
  }
}
