// lib/calculator_controller.dart

import 'package:dago_valley_explore/data/models/house_model.dart';

enum PaymentMethod { kprSyariah, developer }

class CalculatorResult {
  final double dp;
  final double hargaSetelahDiskon;
  final double cicilanBulanan;
  final double totalPembayaran; // dp + cicilanBulanan * months
  final int months;

  CalculatorResult({
    required this.dp,
    required this.hargaSetelahDiskon,
    required this.cicilanBulanan,
    required this.totalPembayaran,
    required this.months,
  });
}

class CashcalculatorController {
  /// hitung DP berdasarkan metode
  /// jika developer dan tanpaDp true => dp = 0
  double calculateDp({
    required int harga,
    required PaymentMethod method,
    required bool tanpaDp,
  }) {
    if (method == PaymentMethod.developer) {
      if (tanpaDp) return 0.0;
      return harga * 0.3; // 30%
    } else {
      return harga * 0.2; // 20% KPR Syariah
    }
  }

  /// terima diskon sebagai salah satu: nominalRp (lebih prioritas) atau persen.
  double applyDiskon({
    required int harga,
    double? diskonNominal,
    double? diskonPersen,
  }) {
    if (diskonNominal != null && diskonNominal > 0) {
      final v = harga - diskonNominal;
      return v < 0 ? 0.0 : v.toDouble();
    }
    if (diskonPersen != null && diskonPersen > 0) {
      final v = harga - (harga * (diskonPersen / 100.0));
      return v < 0 ? 0.0 : v.toDouble();
    }
    return harga.toDouble();
  }

  /// cicilan bulanan (flat): (hargaSetelahDiskon - dp) / (tenor * 12)
  double calculateMonthlyInstallment({
    required double hargaSetelahDiskon,
    required double dp,
    required int tenorYears,
  }) {
    final months = tenorYears * 12;
    final pokok = hargaSetelahDiskon - dp;
    if (months <= 0) return 0.0;
    if (pokok <= 0) return 0.0;
    return pokok / months;
  }

  /// buat summary result
  CalculatorResult compute({
    required HouseModel model,
    required PaymentMethod method,
    required bool tanpaDp,
    double? diskonNominal,
    double? diskonPersen,
    required int tenorYears,
  }) {
    final harga = model.hargaCash;
    final hargaSetelahDiskon = applyDiskon(
      harga: harga,
      diskonNominal: diskonNominal,
      diskonPersen: diskonPersen,
    );
    final dp = calculateDp(harga: harga, method: method, tanpaDp: tanpaDp);
    final monthly = calculateMonthlyInstallment(
      hargaSetelahDiskon: hargaSetelahDiskon,
      dp: dp,
      tenorYears: tenorYears,
    );
    final months = tenorYears * 12;
    final total = dp + (monthly * months);
    return CalculatorResult(
      dp: dp,
      hargaSetelahDiskon: hargaSetelahDiskon,
      cicilanBulanan: monthly,
      totalPembayaran: total,
      months: months,
    );
  }

  /// generate tabel angsuran per bulan, with label month-year, starting at startDate
  List<Map<String, dynamic>> generateMonthlySchedule({
    required double monthlyInstallment,
    required int months,
    DateTime? startDate,
  }) {
    final List<Map<String, dynamic>> rows = [];
    DateTime date = startDate ?? DateTime.now();
    // normalize to first day of current month
    date = DateTime(date.year, date.month, 1);
    for (int i = 0; i < months; i++) {
      final row = {
        'no': i + 1,
        'month': date.month,
        'year': date.year,
        'label': "${_monthName(date.month)} ${date.year}",
        'amount': monthlyInstallment,
      };
      rows.add(row);
      // next month
      date = DateTime(date.year, date.month + 1, 1);
    }
    return rows;
  }

  String _monthName(int m) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    if (m < 1 || m > 12) return '';
    return names[m];
  }
}
