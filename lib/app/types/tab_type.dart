import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabType {
  homepage,
  siteplanpage,
  virtualtourpage,
  mortgagepage,
  cashcalculatorpage,
  licenselegaldocumentpage,
  bookingonlinepage,
}

extension TabItem on TabType {
  Icon get icon {
    switch (this) {
      case TabType.homepage:
        return Icon(CupertinoIcons.home, size: 25);
      case TabType.siteplanpage:
        return Icon(CupertinoIcons.map, size: 25);
      case TabType.virtualtourpage:
        return Icon(Icons.threesixty, size: 25);
      case TabType.mortgagepage:
        return Icon(CupertinoIcons.money_dollar, size: 25);
      case TabType.cashcalculatorpage:
        return Icon(Icons.calculate, size: 25);
      case TabType.licenselegaldocumentpage:
        return Icon(CupertinoIcons.doc_text, size: 25);
      case TabType.bookingonlinepage:
        return Icon(CupertinoIcons.book, size: 25);
    }
  }

  String get title {
    switch (this) {
      case TabType.homepage:
        return "Dashboard";
      case TabType.siteplanpage:
        return "Site Plan Interaktif";
      case TabType.virtualtourpage:
        return "Virtual Tour";
      case TabType.mortgagepage:
        return "Simulasi KPR";
      case TabType.cashcalculatorpage:
        return "Kalkulator Cash Bertahap";
      case TabType.licenselegaldocumentpage:
        return "Dokumen Perizinan & Legalitas";
      case TabType.bookingonlinepage:
        return "Booking Online";
    }
  }
}
