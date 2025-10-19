import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:dago_valley_explore/presentation/controllers/cashcalculator/cashcalculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CashcalculatorPage extends StatefulWidget {
  const CashcalculatorPage({Key? key}) : super(key: key);

  @override
  State<CashcalculatorPage> createState() => _CashcalculatorPageState();
}

class _CashcalculatorPageState extends State<CashcalculatorPage> {
  HouseModel? selectedModel;
  PaymentMethod paymentMethod = PaymentMethod.kprSyariah;
  final TextEditingController _diskonRpController = TextEditingController();
  final TextEditingController _diskonPersenController = TextEditingController();
  bool tanpaDp = false;
  double? diskonNominal;
  double? diskonPersen;
  int tenor = 5;
  final controller = CashcalculatorController();

  final rupiahFormat = NumberFormat("#,###", "id_ID");

  List<int> get tenorOptions {
    if (paymentMethod == PaymentMethod.kprSyariah) {
      return [5, 10, 15, 20];
    } else {
      return [1, 2, 3, 4];
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = selectedModel != null
        ? controller.compute(
            model: selectedModel!,
            method: paymentMethod,
            tanpaDp: tanpaDp,
            diskonNominal: diskonNominal,
            diskonPersen: diskonPersen,
            tenorYears: tenor,
          )
        : null;

    final cardColor = Colors.grey[900];

    return Scaffold(
      backgroundColor: Color(121212),
      body: SafeArea(
        child: Row(
          children: [
            // Kalkulator - 60%
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Card(
                        elevation: 0,
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView(
                            children: [
                              const Text(
                                'Model & Tipe',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ), // outline grey
                                  borderRadius: BorderRadius.circular(
                                    4,
                                  ), // radius 4
                                ),
                                child: DropdownButton<HouseModel>(
                                  isExpanded: true,
                                  value: selectedModel,
                                  hint: const Text(
                                    'Pilih model rumah',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  dropdownColor: cardColor,
                                  focusColor: cardColor,
                                  underline:
                                      const SizedBox(), // hilangkan underline default
                                  items: houseModels.map((m) {
                                    return DropdownMenuItem(
                                      value: m,
                                      child: Text(
                                        '${m.displayName} - Rp. ${_formatCurrency(m.hargaCash.round())}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (v) =>
                                      setState(() => selectedModel = v),
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Text(
                                'Metode Pembayaran',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<PaymentMethod>(
                                      title: const Text(
                                        'KPR Syariah (DP 20%)',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      value: PaymentMethod.kprSyariah,
                                      groupValue: paymentMethod,
                                      onChanged: (v) {
                                        setState(() {
                                          paymentMethod = v!;
                                          tanpaDp = false;
                                          tenor = 5;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<PaymentMethod>(
                                      title: const Text(
                                        'Developer (DP 30%)',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      value: PaymentMethod.developer,
                                      groupValue: paymentMethod,
                                      onChanged: (v) {
                                        setState(() {
                                          paymentMethod = v!;
                                          tenor = 1;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Tenor (tahun)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),

                              Slider(
                                value: tenor.toDouble(),
                                divisions: tenorOptions.length - 1,
                                min: tenorOptions.first.toDouble(),
                                max: tenorOptions.last.toDouble(),
                                label: '$tenor Tahun',
                                onChanged: (v) =>
                                    setState(() => tenor = v.round()),
                              ),
                              Center(
                                child: Text(
                                  '$tenor Tahun',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (paymentMethod == PaymentMethod.developer)
                                Row(
                                  children: [
                                    const Text(
                                      'Tanpa DP',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    Switch(
                                      value: tanpaDp,
                                      onChanged: (v) =>
                                          setState(() => tanpaDp = v),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 16),
                              const Text(
                                'DP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey.shade800,
                                ),
                                child: Text(
                                  selectedModel == null
                                      ? 'Pilih model dulu'
                                      : 'Rp ${_formatCurrency(controller.calculateDp(harga: selectedModel!.hargaCash, method: paymentMethod, tanpaDp: tanpaDp).round())}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              const Text(
                                'Diskon',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        TextField(
                                          controller: _diskonRpController,
                                          enabled: diskonPersen == null,
                                          decoration: InputDecoration(
                                            labelText: 'Diskon (Rp)',
                                            border: const OutlineInputBorder(),
                                            suffixIcon: diskonNominal != null
                                                ? IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                    ),
                                                    onPressed: () {
                                                      _diskonRpController
                                                          .clear();
                                                      setState(() {
                                                        diskonNominal = null;
                                                      });
                                                    },
                                                  )
                                                : null,
                                          ),
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          onChanged: (v) {
                                            String cleaned = v.replaceAll(
                                              '.',
                                              '',
                                            );
                                            double? val = double.tryParse(
                                              cleaned,
                                            );
                                            if (val != null) {
                                              setState(() {
                                                diskonNominal = val;
                                                diskonPersen = null;
                                              });
                                              _diskonRpController
                                                  .value = TextEditingValue(
                                                text: rupiahFormat.format(val),
                                                selection:
                                                    TextSelection.collapsed(
                                                      offset: rupiahFormat
                                                          .format(val)
                                                          .length,
                                                    ),
                                              );
                                            } else if (v.isEmpty) {
                                              setState(
                                                () => diskonNominal = null,
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        TextField(
                                          controller: _diskonPersenController,
                                          enabled: diskonNominal == null,
                                          decoration: InputDecoration(
                                            labelText: 'Diskon (%)',
                                            border: const OutlineInputBorder(),
                                            suffixIcon: diskonPersen != null
                                                ? IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                    ),
                                                    onPressed: () {
                                                      _diskonPersenController
                                                          .clear();
                                                      setState(() {
                                                        diskonPersen = null;
                                                      });
                                                    },
                                                  )
                                                : null,
                                          ),
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          onChanged: (v) => setState(() {
                                            diskonPersen = (v.trim().isEmpty)
                                                ? null
                                                : double.tryParse(v.trim());
                                            if (diskonPersen != null)
                                              diskonNominal = null;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    if (selectedModel != null && result != null)
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: cardColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Angsuran / Bulan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${(diskonNominal != null || diskonPersen != null) ? _formatCurrency(result.cicilanBulananSetelahDiskon.round()) : _formatCurrency(result.cicilanBulanan.round())}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (diskonNominal != null ||
                                        diskonPersen != null)
                                      Column(
                                        children: [
                                          Text(
                                            'Rp ${_formatCurrency(result.totalPembayaran.round())}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: Colors.red,
                                              decorationThickness: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Rp ${_formatCurrency(result.hargaSetelahDiskon.round())}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Text(
                                        'Rp ${_formatCurrency(result.totalPembayaran.round())}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Panel Kanan tetap sama
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  child: DefaultTabController(
                    length: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        children: [
                          Material(
                            color: cardColor,
                            child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.green.shade700,
                              tabs: const [
                                Tab(text: 'Ringkasan'),
                                Tab(text: 'Tabel Angsuran'),
                                Tab(text: 'Perbandingan'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Syarat & Ketentuan:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...List.generate(_ringkasanList.length, (
                                        index,
                                      ) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${index + 1}. ',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  height: 1.5,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _ringkasanList[index],
                                                  textAlign: TextAlign
                                                      .justify, // ✅ teks rata kiri-kanan
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: selectedModel == null || result == null
                                      ? const Center(
                                          child: Text(
                                            'Pilih model & hitung terlebih dahulu',
                                          ),
                                        )
                                      : _buildScheduleTable(result),
                                ),

                                const Center(
                                  child: Text(
                                    'Perbandingan KPR Syariah vs Developer',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    int cnt = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]);
      cnt++;
      if (cnt == 3 && i != 0) {
        buf.write('.');
        cnt = 0;
      }
    }
    final rev = buf.toString().split('').reversed.join();
    return rev;
  }

  Widget _buildScheduleTable(CalculatorResult result) {
    final schedule = controller.generateMonthlySchedule(
      monthlyInstallment: diskonNominal != null || diskonPersen != null
          ? result.cicilanBulananSetelahDiskon
          : result.cicilanBulanan,
      months: result.months,
      startDate: DateTime.now(),
    );
    final startLabel = schedule.first['label'];
    final endLabel = schedule.last['label'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Periode: $startLabel - $endLabel',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: DataTable(
                border: TableBorder.all(color: Colors.grey, width: 1),
                columns: const [
                  DataColumn(
                    label: Text('No', style: TextStyle(color: Colors.grey)),
                  ),
                  DataColumn(
                    label: Text('Bulan', style: TextStyle(color: Colors.grey)),
                  ),
                  DataColumn(
                    label: Text(
                      'Nominal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
                rows: schedule
                    .map(
                      (r) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              '${r['no']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${r['label']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Rp ${_formatCurrency((r['amount'] as double).round())}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final List<String> _ringkasanList = [
  'Harga tidak mengikat dan dapat berubah sewaktu-waktu tanpa pemberitahuan terlebih dahulu.',
  'Harga sudah termasuk biaya Notaris, Splitizing Sertipikat, AJB, BBN Sertipikat & IMB.',
  'Harga belum termasuk BPHTB & PPN (apabila terjadi perubahan tarif PPN maka selisih PPN ditanggung dan wajib dibayarkan oleh pembeli).',
  'Harga sudah termasuk biaya pemasangan daya listrik PLN dan suplai air bersih.',
  'Pembayaran Booking Fee sebesar Rp. 10.000.000,- (uang tidak dapat dikembalikan apabila konsumen melakukan pembatalan).',
  'Pembayaran pembelian unit cash keras dilakukan selambat-lambatnya 1 bulan setelah pembayaran Booking Fee.',
  'Pembayaran DP untuk pembelian unit secara KPR dilakukan selambat-lambatnya 14 hari setelah pembayaran Booking Fee.',
  'Persyaratan pembelian unit secara KPR: FC KTP/Paspor suami & istri, Surat Nikah, KK, NPWP, Rekening Koran 3 bulan terakhir, Slip Gaji, SK awal & akhir.',
  'Apabila dilakukan perubahan/pemindahan lokasi kavling yang telah dipilih sebelumnya maka akan dikenakan biaya sebesar Rp. 3.000.000,-',
  'Pembayaran melalui setoran tunai/transfer bank ditujukan ke rekening BSI (Bank Syariah Indonesia), nomor: 722-127-3607, a.n. PT. Cisitu Indah Lestari.',
  'Unit bangunan rumah indent (serah terima bangunan 12 bulan setelah pembayaran DP lunas atau pembayaran minimal 30% dari harga total diterima oleh Developer).',
  'Luas/spesifikasi tanah dan bangunan dapat berubah menyesuaikan ketentuan legalitas dari BPN, ketentuan perijinan dari pemerintahan kota dan/atau menjadi kebijakan Developer.',
];
