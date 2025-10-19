import 'package:dago_valley_explore/presentation/controllers/dashboard/dashboard_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/siteplan_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail/detail_page.dart';

class SiteplanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Color(121212),
      navigationBar: CupertinoNavigationBar(middle: Text('')),
      child: Center(
        child: Text("Kawasan 360", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
