import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/types/tab_type.dart';
import 'package:dago_valley_explore/presentation/controllers/auth/auth_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/bookingonline/bookingonline_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/cashcalculator/cashcalculator_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/dashboard/dashboard_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/licenselegaldocument/licenselegaldocument_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/mortgage/mortgage_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/siteplan_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/virtualtour/virtualtour_binding.dart';
import 'package:dago_valley_explore/presentation/pages/bookingonline/bookingonline_page.dart';
import 'package:dago_valley_explore/presentation/pages/cashcalculator/cashcalculator_page.dart';
import 'package:dago_valley_explore/presentation/pages/dashboard/dashboard_page.dart';
import 'package:dago_valley_explore/presentation/pages/licenselegaldocument/licenselegaldocument_page.dart';
import 'package:dago_valley_explore/presentation/pages/mortgage/mortgage_page.dart';
import 'package:dago_valley_explore/presentation/pages/siteplan/siteplan_page.dart';
import 'package:dago_valley_explore/presentation/pages/virtualtour/virtualtour_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: TabType.values
            .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.title))
            .toList(),
        inactiveColor: AppColors.lightGrey,
        activeColor: AppColors.primary,
      ),
      tabBuilder: (context, index) {
        final type = TabType.values[index];
        switch (type) {
          case TabType.homepage:
            DashboardBinding().dependencies();
            return DashboardPage();
          case TabType.siteplanpage:
            SiteplanBinding().dependencies();
            return SiteplanPage();
          case TabType.virtualtourpage:
            VirtualtourBinding().dependencies();
            return VirtualtourPage();
          case TabType.mortgagepage:
            MortgageBinding().dependencies();
            return MortgagePage();
          case TabType.cashcalculatorpage:
            CashcalculatorBinding().dependencies();
            return CashcalculatorPage();
          case TabType.licenselegaldocumentpage:
            LicenselegaldocumentBinding().dependencies();
            return LicenselegaldocumentPage();
          case TabType.bookingonlinepage:
            BookingonlineBinding().dependencies();
            return BookingonlinePage();
        }
      },
    );
  }
}
