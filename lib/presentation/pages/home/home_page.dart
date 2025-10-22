import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/app/types/tab_type.dart';
import 'package:dago_valley_explore/presentation/components/drawer/custom_drawer.dart';
import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/bookingonline/bookingonline_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/cashcalculator/cashcalculator_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/dashboard/dashboard_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/licenselegaldocument/licenselegaldocument_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/siteplan_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/virtualtour/virtualtour_binding.dart';
import 'package:dago_valley_explore/presentation/pages/bookingonline/bookingonline_page.dart';
import 'package:dago_valley_explore/presentation/pages/cashcalculator/cashcalculator_page.dart';
import 'package:dago_valley_explore/presentation/pages/dashboard/dashboard_page.dart';
import 'package:dago_valley_explore/presentation/pages/licenselegaldocument/license_legal_document_page.dart';
import 'package:dago_valley_explore/presentation/pages/siteplan/siteplan_page.dart';
import 'package:dago_valley_explore/presentation/pages/virtualtour/virtualtour_page.dart';
import 'package:dago_valley_explore/screen/dasbor_awal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<SidebarController> {
  const HomePage({Key? key}) : super(key: key);

  // Method untuk mendapatkan widget sesuai tab aktif
  Widget _getPageForTab(TabType tab) {
    switch (tab) {
      case TabType.homepage:
        DashboardBinding().dependencies();
        return DasborAwal();
      case TabType.siteplanpage:
        SiteplanBinding().dependencies();
        return SiteplanPage();
      case TabType.productpage:
        VirtualtourBinding().dependencies();
        return VirtualtourPage();
      case TabType.calculatorpage:
        CashcalculatorBinding().dependencies();
        return CashcalculatorPage();
      case TabType.licenselegaldocumentpage:
        LicenselegaldocumentBinding().dependencies();
        return LicenseLegalDocumentPage();
      case TabType.bookingonlinepage:
        BookingonlineBinding().dependencies();
        return BookingonlinePage();
      default:
        DashboardBinding().dependencies();
        return DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get ThemeController
    final themeController = Get.find<ThemeController>();

    return GetX<SidebarController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: HexColor("121212"),
          body: Row(
            children: [
              // Drawer/Sidebar selalu terlihat di sisi kiri
              const CustomDrawer(),

              // Konten utama yang berubah sesuai tab aktif
              Expanded(
                child: Container(
                  color: HexColor("121212"),
                  child: _getPageForTab(controller.activeTab),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton: Obx(
            () => Container(
              margin: EdgeInsets.all(8),
              child: FloatingActionButton(
                onPressed: () {
                  themeController.toggleTheme();
                },
                backgroundColor: themeController.isDarkMode
                    ? Colors.grey[800]
                    : Colors.white,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(turns: animation, child: child);
                  },
                  child: Icon(
                    themeController.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    key: ValueKey(themeController.isDarkMode),
                    color: themeController.isDarkMode
                        ? Colors.yellow
                        : Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
