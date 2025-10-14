import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/app/types/tab_type.dart';
import 'package:dago_valley_explore/presentation/components/drawer/bottom_user_info.dart';
import 'package:dago_valley_explore/presentation/components/drawer/custom_list_tile.dart';
import 'package:dago_valley_explore/presentation/components/drawer/header.dart';
import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends GetView<SidebarController> {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SidebarController>(
      init: controller,
      builder: (_) {
        return SafeArea(
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 500),
            width: controller.isCollapsed ? 300 : 85,
            margin: const EdgeInsets.only(bottom: 10, top: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: HexColor("EBEBEB"),
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
                  CustomListTile(
                    isActive: false,
                    isCollapsed: controller.isCollapsed,
                    icon: Icons.settings,
                    svgIcon: "assets/menu/hotline_icon.svg",
                    title: 'Settings',
                    infoCount: 0,
                    onTap: () {
                      Get.snackbar(
                        'Settings',
                        'Settings menu clicked',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
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
