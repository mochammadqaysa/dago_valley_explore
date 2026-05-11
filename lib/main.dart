import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/services/local_storage.dart';
import 'app/util/dependency.dart';
import 'app/util/platform_helper.dart';
import 'presentation/app.dart';

// Conditional import for window_manager (only available on desktop windows)
import 'main_stub.dart'
    if (dart.library.io) 'main_desktop.dart'
    as desktop_init;

void main() async {
  DependencyCreator.init();
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () async {
      // Initialize window manager only on desktop platforms
      if (PlatformHelper.isDesktop) {
        await desktop_init.initDesktopWindow();
      }
      await initServices();
      runApp(App());
    },
    (error, stack) async {
      final msg = 'Uncaught error: $error\n$stack\n';
      if (kDebugMode) {
        print(msg);
      }
      // On desktop, optionally log to file
      if (PlatformHelper.isDesktop) {
        desktop_init.logError(msg);
      }
    },
  );
}

initServices() async {
  print('starting services ...');
  await Get.putAsync(() => LocalStorageService().init());
  print('All services started...');
}
