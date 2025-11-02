import 'dart:io';

import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/app/types/tab_type.dart';
import 'package:dago_valley_explore/presentation/components/drawer/bottom_user_info.dart';
import 'package:dago_valley_explore/presentation/components/drawer/custom_list_tile.dart';
import 'package:dago_valley_explore/presentation/components/drawer/header.dart';
import 'package:dago_valley_explore/presentation/controllers/fullscreen/fullscreen_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomDrawer extends GetView<SidebarController> {
  const CustomDrawer({Key? key}) : super(key: key);

  void _showExitConfirmation(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: themeController.isDarkMode
            ? HexColor("1C1C19")
            : HexColor("EBEBEB"),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(Icons.warning_rounded, size: 64, color: Colors.orange),
              const SizedBox(height: 16),

              // Title
              Text(
                'Konfirmasi Keluar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: themeController.isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Tombol Batal
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(); // Tutup dialog
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: themeController.isDarkMode
                              ? Colors.white54
                              : Colors.black54,
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 16,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Keluar
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _exitApp(); // ✅ Exit aplikasi
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true, // Bisa ditutup dengan klik di luar dialog
    );
  }

  // ✅ Method untuk exit aplikasi
  void _exitApp() {
    if (Platform.isAndroid || Platform.isIOS) {
      // Untuk Mobile
      SystemNavigator.pop();
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Untuk Desktop
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final fullscreenController = Get.find<FullscreenController>();
    return GetX<SidebarController>(
      init: controller,
      builder: (_) {
        return SafeArea(
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 500),
            width: controller.isCollapsed ? 300 : 120,
            margin: const EdgeInsets.only(bottom: 23, top: 23, left: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              // color: HexColor("EBEBEB"),
              // color: HexColor("1C1C19"),
              color: themeController.isDarkMode
                  ? HexColor("1C1C19")
                  : HexColor("EBEBEB"),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  CustomDrawerHeader(
                    isColapsed: controller.isCollapsed,
                    onToggle: controller.toggleCollapse,
                  ),
                  const Spacer(),
                  ...TabType.values
                      .where((e) => e != TabType.bookingonlinepage)
                      .map(
                        (e) => CustomListTile(
                          isActive: controller.isTabActive(e),
                          isCollapsed: controller.isCollapsed,
                          icon: Icons.home_max,
                          svgIcon: e.svgIcon,
                          title: e.title,
                          infoCount: 0,
                          onTap: () => controller.setActiveTab(e),
                        ),
                      )
                      .toList(),
                  const Spacer(),
                  Visibility(
                    visible: true,
                    child: CustomListTile(
                      isActive: false,
                      isCollapsed: controller.isCollapsed,
                      icon: Icons.exit_to_app,
                      svgIcon: "assets/menu/hotline_icon.svg",
                      title: 'Exit App',
                      infoCount: 0,
                      onTap: () {
                        _showExitConfirmation(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // BottomUserInfo(isCollapsed: controller.isCollapsed),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
