import 'package:dago_valley_explore/data/models/house_model.dart';

enum PaymentMethod { kprSyariah, developer }

class CalculatorResult {
  final double dp;
  final double hargaSetelahDiskon;
  final double cicilanBulanan;
  final double cicilanBulananSetelahDiskon;
  final double totalPembayaran;
  final double totalPembayaranSetelahDiskon;
  final int months;

  CalculatorResult({
    required this.dp,
    required this.hargaSetelahDiskon,
    required this.cicilanBulanan,
    required this.cicilanBulananSetelahDiskon,
    required this.totalPembayaran,
    required this.totalPembayaranSetelahDiskon,
    required this.months,
  });
}

class CashcalculatorController {
  /// Hitung DP (masih sama)
  double calculateDp({
    required int harga,
    required PaymentMethod method,
    required bool tanpaDp,
  }) {
    if (method == PaymentMethod.developer) {
      if (tanpaDp) return 0.0;
      return harga * 0.3;
    } else {
      return harga * 0.2;
    }
  }

  /// Ambil data cicilan dan total dari model
  Map<String, double> _getFromModel({
    required HouseModel model,
    required PaymentMethod method,
    required bool tanpaDp,
    required int tenorYears,
  }) {
    String key;
    if (method == PaymentMethod.kprSyariah) {
      key = "kpr_syariah";
    } else {
      key = tanpaDp ? "developer_tanpa_dp" : "developer_dp";
    }

    final data = model.cicilanData[key]?[tenorYears];
    return {
      "cicilan": (data?["cicilan"] ?? 0).toDouble(),
      "total": (data?["total"] ?? 0).toDouble(),
    };
  }

  /// Fungsi utama compute()
  CalculatorResult compute({
    required HouseModel model,
    required PaymentMethod method,
    required bool tanpaDp,
    double? diskonNominal,
    double? diskonPersen,
    required int tenorYears,
  }) {
    final harga = model.hargaCash;
    final dp = calculateDp(harga: harga, method: method, tanpaDp: tanpaDp);
    final months = tenorYears * 12;

    final data = _getFromModel(
      model: model,
      method: method,
      tanpaDp: tanpaDp,
      tenorYears: tenorYears,
    );

    final total = data["total"]!;
    final cicilan = data["cicilan"]!;

    // Jika ada diskon manual
    double totalAfterDiskon = total;
    double diskon = 0.0;
    print({'totalPembayaran BEFORE diskon': totalAfterDiskon});
    if (diskonNominal != null && diskonNominal > 0) {
      diskon = diskonNominal;
      totalAfterDiskon = (total - diskonNominal).clamp(0, double.infinity);
    } else if (diskonPersen != null && diskonPersen > 0) {
      diskon = (total * diskonPersen / 100).clamp(2, double.infinity);
      totalAfterDiskon = (total * (1 - diskonPersen / 100)).clamp(
        0,
        double.infinity,
      );
    }

    final diskonCicilan = diskon > 0 ? diskon / months : 0;
    final cicilanAfterDiskon = (diskonCicilan > 0)
        ? cicilan - diskonCicilan
        : 0.0;

    return CalculatorResult(
      dp: dp,
      hargaSetelahDiskon: totalAfterDiskon,
      cicilanBulanan: cicilan,
      cicilanBulananSetelahDiskon: cicilanAfterDiskon,
      totalPembayaran: total,
      totalPembayaranSetelahDiskon: totalAfterDiskon,
      months: months,
    );
  }

  /// Tabel cicilan (biarkan sama)
  List<Map<String, dynamic>> generateMonthlySchedule({
    required double monthlyInstallment,
    required int months,
    DateTime? startDate,
  }) {
    final List<Map<String, dynamic>> rows = [];
    DateTime date = startDate ?? DateTime.now();
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
