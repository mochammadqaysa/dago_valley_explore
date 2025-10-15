import 'package:dago_valley_explore/presentation/components/glass/glassy.dart';
import 'package:dago_valley_explore/presentation/components/glass/glassy_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/services/local_storage.dart';
import 'app/util/dependency.dart';
import 'presentation/app.dart';

void main() async {
  DependencyCreator.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  Glassy().setConfig(
    GlassyConfig(
      radius: 8,
      backgroundColor: Colors.grey.shade100,
      backgroundOpacity: 0.1,
      borderOpacity: 0.2,
    ),
  );
  runApp(App());
}

initServices() async {
  print('starting services ...');
  await Get.putAsync(() => LocalStorageService().init());
  print('All services started...');
}
