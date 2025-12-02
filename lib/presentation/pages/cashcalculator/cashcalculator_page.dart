import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:dago_valley_explore/presentation/controllers/cashcalculator/cashcalculator_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

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
  final TextEditingController _dpController = TextEditingController();

  // Add FocusNodes for keyboard management
  final FocusNode _diskonRpFocus = FocusNode();
  final FocusNode _diskonPersenFocus = FocusNode();
  final FocusNode _dpFocus = FocusNode();

  bool tanpaDp = false;
  double? diskonNominal;
  double? diskonPersen;
  double? customDp;
  int tenor = 5;
  double marginPersen = 11.0;
  double marginSyariah = 0.0;
  double marginDeveloper = 0.0;

  // Track which field is focused
  TextEditingController? _activeController;
  bool _showKeyboard = false;

  final controller = CashcalculatorController();

  // Formatter untuk currency
  final currencyFormatter = NumberFormat("#,##0", "id_ID");

  final LocalStorageService _storage = Get.find<LocalStorageService>();

  List<int> get tenorOptions {
    if (paymentMethod == PaymentMethod.kprSyariah) {
      return [5, 10, 15, 20];
    } else {
      return [1, 2, 3, 4];
    }
  }

  @override
  void initState() {
    super.initState();
    final cachedKpr = _storage.kprCalculators;

    marginSyariah = cachedKpr?.first.marginBankSyariahValue ?? 11.0;
    marginDeveloper = cachedKpr?.first.marginDeveloperValue ?? 5.25;

    marginPersen = paymentMethod == PaymentMethod.kprSyariah
        ? marginSyariah
        : marginDeveloper;

    // Add listeners to focus nodes
    _diskonRpFocus.addListener(() {
      if (_diskonRpFocus.hasFocus) {
        setState(() {
          _activeController = _diskonRpController;
          _showKeyboard = true;
        });
      }
    });

    _diskonPersenFocus.addListener(() {
      if (_diskonPersenFocus.hasFocus) {
        setState(() {
          _activeController = _diskonPersenController;
          _showKeyboard = true;
        });
      }
    });

    _dpFocus.addListener(() {
      if (_dpFocus.hasFocus) {
        setState(() {
          _activeController = _dpController;
          _showKeyboard = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _diskonRpController.dispose();
    _diskonPersenController.dispose();
    _dpController.dispose();
    _diskonRpFocus.dispose();
    _diskonPersenFocus.dispose();
    _dpFocus.dispose();
    super.dispose();
  }

  void _handleKeyPress(String value) {
    if (_activeController == null) return;

    // Get current text and remove all formatting
    // FIX: Ganti '. ' menjadi '.' karena NumberFormat menghasilkan titik tanpa spasi
    final currentText = _activeController!.text
        .replaceAll('.', '') // ← PERBAIKAN DI SINI
        .replaceAll(',', '')
        .trim();

    String newText;

    if (value == '⌫') {
      // Backspace
      if (currentText.isNotEmpty) {
        newText = currentText.substring(0, currentText.length - 1);
      } else {
        return;
      }
    } else if (value == 'C') {
      // Clear
      newText = '';
    } else if (value == '. ') {
      // Decimal point - handle based on which controller
      if (_activeController == _diskonPersenController) {
        if (!currentText.contains('.')) {
          newText = currentText.isEmpty ? '0.' : currentText + '.';
        } else {
          return;
        }
      } else {
        return; // Don't allow decimal for rupiah fields
      }
    } else {
      // Number
      // Prevent leading zeros unless it's just "0"
      if (currentText == '0' && value == '0') {
        return;
      }
      if (currentText == '0' && value != '. ') {
        newText = value;
      } else {
        newText = currentText + value;
      }
    }

    // Update the appropriate field
    if (_activeController == _dpController) {
      _updateDpField(newText);
    } else if (_activeController == _diskonRpController) {
      _updateDiskonRpField(newText);
    } else if (_activeController == _diskonPersenController) {
      _updateDiskonPersenField(newText);
    }
  }

  void _updateDpField(String value) {
    if (value.isEmpty) {
      setState(() {
        customDp = null;
      });
      _dpController.clear();
      return;
    }

    // Parse the raw number (without formatting)
    double? val = double.tryParse(value);

    if (val != null && val >= 0) {
      setState(() {
        customDp = val;
      });

      // Format with thousand separator
      String formattedText = currencyFormatter.format(val.toInt());

      // Update controller with formatted text
      _dpController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }

  void _updateDiskonRpField(String value) {
    if (value.isEmpty) {
      setState(() {
        diskonNominal = null;
      });
      _diskonRpController.clear();
      return;
    }

    // Parse the raw number (without formatting)
    double? val = double.tryParse(value);

    if (val != null && val >= 0) {
      setState(() {
        diskonNominal = val;
        diskonPersen = null;
      });

      // Format with thousand separator
      String formattedText = currencyFormatter.format(val.toInt());

      // Update controller with formatted text
      _diskonRpController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }

  void _updateDiskonPersenField(String value) {
    if (value.isEmpty) {
      setState(() {
        diskonPersen = null;
      });
      _diskonPersenController.clear();
      return;
    }

    double? val = double.tryParse(value);
    if (val != null && val >= 0 && val <= 100) {
      setState(() {
        diskonPersen = val;
        diskonNominal = null;
      });

      _diskonPersenController.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final screenWidth = MediaQuery.of(context).size.width;

    final result = selectedModel != null
        ? controller.compute(
            model: selectedModel!,
            method: paymentMethod,
            tanpaDp: tanpaDp,
            diskonNominal: diskonNominal,
            diskonPersen: diskonPersen,
            tenorYears: tenor,
            marginPersen: marginPersen,
            customDp: customDp,
          )
        : null;

    print(
      '💾 Cached KPR Calculators for margins: Syariah: $marginSyariah, Developer: $marginDeveloper',
    );

    return Obx(() {
      final cardColor = themeController.isDarkMode
          ? Colors.grey[900]
          : AppColors.white;

      final textColor = themeController.isDarkMode
          ? Colors.white
          : Colors.black;

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Kalkulator - 60%
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32.0,
                          horizontal: 8.0,
                        ),
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
                                      Text(
                                        'mortgage_simulation'.tr,
                                        style: TextStyle(
                                          fontSize: 32,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'mortgage_simulation_desc'.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        'model_and_type'.tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: DropdownButton<HouseModel>(
                                          isExpanded: true,
                                          value: selectedModel,
                                          hint: Text(
                                            'choose_house_model'.tr,
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          dropdownColor: cardColor,
                                          focusColor: cardColor,
                                          underline: const SizedBox(),
                                          items: houseModels.map((m) {
                                            return DropdownMenuItem(
                                              value: m,
                                              child: Text(
                                                '${m.displayName} - Rp.  ${_formatCurrencyDisplay(m.hargaCash.round())}',
                                                style: TextStyle(
                                                  color: textColor,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (v) {
                                            setState(() {
                                              selectedModel = v;
                                              customDp = null;
                                              _dpController.clear();
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      Text(
                                        'payment_method'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RadioListTile<PaymentMethod>(
                                              title: Text(
                                                'sharia_bank_mortgage'.tr,
                                                style: TextStyle(
                                                  color: textColor,
                                                ),
                                              ),
                                              value: PaymentMethod.kprSyariah,
                                              groupValue: paymentMethod,
                                              onChanged: (v) {
                                                setState(() {
                                                  paymentMethod = v!;
                                                  tanpaDp = false;
                                                  tenor = 5;
                                                  marginPersen = marginSyariah;
                                                  customDp = null;
                                                  _dpController.clear();
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: RadioListTile<PaymentMethod>(
                                              title: Text(
                                                'developer_mortgage'.tr,
                                                style: TextStyle(
                                                  color: textColor,
                                                ),
                                              ),
                                              value: PaymentMethod.developer,
                                              groupValue: paymentMethod,
                                              onChanged: (v) {
                                                setState(() {
                                                  paymentMethod = v!;
                                                  tenor = 4;
                                                  marginPersen =
                                                      marginDeveloper;
                                                  customDp = null;
                                                  _dpController.clear();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'tenor'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      Slider(
                                        value: tenor.toDouble(),
                                        divisions: tenorOptions.length - 1,
                                        min: tenorOptions.first.toDouble(),
                                        max: tenorOptions.last.toDouble(),
                                        label: '$tenor ${'years'.tr}',
                                        onChanged: (v) =>
                                            setState(() => tenor = v.round()),
                                      ),
                                      Center(
                                        child: Text(
                                          '$tenor ${'years'.tr}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 16),
                                      if (paymentMethod ==
                                          PaymentMethod.developer)
                                        Row(
                                          children: [
                                            Text(
                                              'no_down_payment'.tr,
                                              style: TextStyle(
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Switch(
                                              value: tanpaDp,
                                              onChanged: (v) {
                                                setState(() {
                                                  tanpaDp = v;
                                                  customDp = null;
                                                  _dpController.clear();
                                                });
                                              },
                                            ),
                                          ],
                                        ),

                                      const SizedBox(height: 16),

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // === Kolom DP ===
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'DP',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                TextField(
                                                  controller: _dpController,
                                                  focusNode: _dpFocus,
                                                  readOnly: true,
                                                  enabled:
                                                      selectedModel != null,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        selectedModel == null
                                                        ? 'choose_house_model_first'
                                                              .tr
                                                        : 'Rp ${_formatCurrencyDisplay(controller.calculateDp(harga: selectedModel!.hargaCash.toDouble(), method: paymentMethod, tanpaDp: tanpaDp).round())}',
                                                    hintStyle: TextStyle(
                                                      color:
                                                          themeController
                                                              .isDarkMode
                                                          ? Colors.grey[600]
                                                          : Colors.grey[500],
                                                    ),
                                                    prefixText: 'Rp ',
                                                    prefixStyle: TextStyle(
                                                      color: textColor,
                                                      fontSize: 16,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    filled: true,
                                                    fillColor: customDp != null
                                                        ? (themeController
                                                                  .isDarkMode
                                                              ? Colors.blue[900]
                                                                    ?.withOpacity(
                                                                      0.3,
                                                                    )
                                                              : Colors.blue[50])
                                                        : (themeController
                                                                  .isDarkMode
                                                              ? Colors.grey[800]
                                                              : Colors
                                                                    .grey[200]),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 12,
                                                        ),
                                                    suffixIcon: customDp != null
                                                        ? IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              color: textColor,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                customDp = null;
                                                                _dpController
                                                                    .clear();
                                                              });
                                                            },
                                                            tooltip:
                                                                'Reset ke default',
                                                          )
                                                        : null,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: textColor,
                                                    fontWeight: customDp != null
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                  onTap: () {
                                                    if (selectedModel != null) {
                                                      setState(() {
                                                        _activeController =
                                                            _dpController;
                                                        _showKeyboard = true;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // === Kolom Margin (%) - Hidden ===
                                          Expanded(
                                            flex: 1,
                                            child: Offstage(
                                              offstage: true,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Margin (%)',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: 'Margin %',
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 12,
                                                            ),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.numberWithOptions(
                                                            decimal: true,
                                                          ),
                                                      style: TextStyle(
                                                        color: textColor,
                                                      ),
                                                      controller:
                                                          TextEditingController(
                                                            text: marginPersen
                                                                .toString(),
                                                          ),
                                                      onChanged: (v) {
                                                        double? val =
                                                            double.tryParse(v);
                                                        if (val != null) {
                                                          setState(
                                                            () => marginPersen =
                                                                val,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // === Kolom Margin KPR - Hidden ===
                                          Expanded(
                                            flex: 1,
                                            child: Offstage(
                                              offstage: true,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'mortgage_margin'.tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                          12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                      color:
                                                          themeController
                                                              .isDarkMode
                                                          ? Colors.grey[800]
                                                          : Colors.grey[200],
                                                    ),
                                                    child: Text(
                                                      selectedModel == null ||
                                                              result == null
                                                          ? 'choose_house_model_first'
                                                                .tr
                                                          : 'Rp ${_formatCurrencyDisplay(result.marginKpr.round())}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),
                                      Text(
                                        'discount'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
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
                                                  controller:
                                                      _diskonRpController,
                                                  focusNode: _diskonRpFocus,
                                                  readOnly: true,
                                                  enabled: diskonPersen == null,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        '${'discount'.tr} (Rp)',
                                                    border:
                                                        const OutlineInputBorder(),
                                                    suffixIcon:
                                                        diskonNominal != null
                                                        ? IconButton(
                                                            icon: const Icon(
                                                              Icons.close,
                                                            ),
                                                            onPressed: () {
                                                              _diskonRpController
                                                                  .clear();
                                                              setState(() {
                                                                diskonNominal =
                                                                    null;
                                                              });
                                                            },
                                                          )
                                                        : null,
                                                  ),
                                                  style: TextStyle(
                                                    color:
                                                        themeController
                                                            .isDarkMode
                                                        ? Colors.grey
                                                        : Colors.black,
                                                  ),
                                                  onTap: diskonPersen == null
                                                      ? () {
                                                          setState(() {
                                                            _activeController =
                                                                _diskonRpController;
                                                            _showKeyboard =
                                                                true;
                                                          });
                                                        }
                                                      : null,
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
                                                  controller:
                                                      _diskonPersenController,
                                                  focusNode: _diskonPersenFocus,
                                                  readOnly: true,
                                                  enabled:
                                                      diskonNominal == null,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        '${'discount'.tr} (%)',
                                                    border:
                                                        const OutlineInputBorder(),
                                                    suffixIcon:
                                                        diskonPersen != null
                                                        ? IconButton(
                                                            icon: const Icon(
                                                              Icons.close,
                                                            ),
                                                            onPressed: () {
                                                              _diskonPersenController
                                                                  .clear();
                                                              setState(() {
                                                                diskonPersen =
                                                                    null;
                                                              });
                                                            },
                                                          )
                                                        : null,
                                                  ),
                                                  style: TextStyle(
                                                    color:
                                                        themeController
                                                            .isDarkMode
                                                        ? Colors.grey
                                                        : Colors.black,
                                                  ),
                                                  onTap: diskonNominal == null
                                                      ? () {
                                                          setState(() {
                                                            _activeController =
                                                                _diskonPersenController;
                                                            _showKeyboard =
                                                                true;
                                                          });
                                                        }
                                                      : null,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Angsuran / Bulan',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: textColor,
                                              ),
                                            ),
                                            Text(
                                              'Rp ${(diskonNominal != null || diskonPersen != null) ? _formatCurrencyDisplay(result.cicilanBulananSetelahDiskon.round()) : _formatCurrencyDisplay(result.cicilanBulanan.round())}',
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            if (diskonNominal != null ||
                                                diskonPersen != null)
                                              Column(
                                                children: [
                                                  Text(
                                                    'Rp ${_formatCurrencyDisplay(result.totalPembayaran.round())}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          Colors.red,
                                                      decorationThickness: 2,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Rp ${_formatCurrencyDisplay(result.hargaSetelahDiskon.round())}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Rp ${_formatCurrencyDisplay(result.totalPembayaran.round())}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: textColor,
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

                    // Panel Kanan - Tabel Angsuran
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32.0,
                          horizontal: 8.0,
                        ),
                        child: Card(
                          color: cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          child: DefaultTabController(
                            length: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                children: [
                                  Material(
                                    color: cardColor,
                                    child: TabBar(
                                      labelColor: textColor,
                                      unselectedLabelColor: Colors.grey,
                                      indicatorColor: Colors.green.shade700,
                                      tabs: [
                                        Tab(text: 'summary'.tr),
                                        Tab(text: 'installment_table'.tr),
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
                                              Text(
                                                '${'terms_n_conditions'.tr}:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              ...List.generate(
                                                _ringkasanList.length,
                                                (index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 4,
                                                        ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${index + 1}.  ',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                themeController
                                                                    .isDarkMode
                                                                ? Colors.grey
                                                                : Colors.black,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            _ringkasanList[index]
                                                                .tr,
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  themeController
                                                                      .isDarkMode
                                                                  ? Colors.grey
                                                                  : Colors
                                                                        .black,
                                                              height: 1.5,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              selectedModel == null ||
                                                  result == null
                                              ? Center(
                                                  child: Text(
                                                    'Pilih model & hitung terlebih dahulu',
                                                    style: TextStyle(
                                                      color:
                                                          themeController
                                                              .isDarkMode
                                                          ? Colors.grey
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                )
                                              : _buildScheduleTable(
                                                  result,
                                                  themeController,
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

              // On-Screen Keyboard - FIXED SIZE
              if (_showKeyboard)
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth * 0.5, // Max 50% dari lebar layar
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 240, // Reduced height
                      width: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode
                            ? Colors.grey[850]
                            : Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Keyboard header with close button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Numeric Keyboard',
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                IconButton(
                                  iconSize: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  icon: Icon(
                                    Icons.keyboard_hide,
                                    color: textColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showKeyboard = false;
                                      _dpFocus.unfocus();
                                      _diskonRpFocus.unfocus();
                                      _diskonPersenFocus.unfocus();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Custom numeric keyboard
                          Expanded(
                            child: _buildCustomKeyboard(themeController),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCustomKeyboard(ThemeController themeController) {
    final buttonColor = themeController.isDarkMode
        ? Colors.grey[800]
        : Colors.white;
    final textColor = themeController.isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: 7 8 9
          Expanded(
            child: Row(
              children: [
                _buildKeyboardButton('7', buttonColor, textColor),
                const SizedBox(width: 6),
                _buildKeyboardButton('8', buttonColor, textColor),
                const SizedBox(width: 6),
                _buildKeyboardButton('9', buttonColor, textColor),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Row 2: 4 5 6
          Expanded(
            child: Row(
              children: [
                _buildKeyboardButton('4', buttonColor, textColor),
                const SizedBox(width: 6),
                _buildKeyboardButton('5', buttonColor, textColor),
                const SizedBox(width: 6),
                _buildKeyboardButton('6', buttonColor, textColor),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Row 3: 1 2 3
          Expanded(
            child: Row(
              children: [
                _buildKeyboardButton('1', buttonColor, textColor),
                const SizedBox(width: 6),
                _buildKeyboardButton('2', buttonColor, textColor),
                const SizedBox(width: 6),
                _buildKeyboardButton('3', buttonColor, textColor),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Row 4: .   0 ⌫
          Expanded(
            child: Row(
              children: [
                _buildKeyboardButton(
                  '.',
                  buttonColor,
                  textColor,
                  enabled: _activeController == _diskonPersenController,
                ),
                const SizedBox(width: 6),
                _buildKeyboardButton('0', buttonColor, textColor),
                const SizedBox(width: 6),
                _buildKeyboardButton('⌫', Colors.orange.shade700, Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Row 5: Clear button
          SizedBox(
            height: 35,
            child: _buildKeyboardButton(
              'Clear',
              Colors.red.shade700,
              Colors.white,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardButton(
    String value,
    Color? backgroundColor,
    Color? textColor, {
    bool fullWidth = false,
    bool enabled = true,
  }) {
    return Expanded(
      child: Material(
        color: enabled ? backgroundColor : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(6),
        elevation: enabled ? 2 : 0,
        child: InkWell(
          onTap: enabled
              ? () => _handleKeyPress(value == 'Clear' ? 'C' : value)
              : null,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontSize: value == 'Clear' ? 14 : 18,
                fontWeight: FontWeight.bold,
                color: enabled ? textColor : Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Format currency untuk display (read-only)
  String _formatCurrencyDisplay(int v) {
    return currencyFormatter.format(v);
  }

  Widget _buildScheduleTable(
    CalculatorResult result,
    ThemeController themeController,
  ) {
    final schedule = result.scheduleTable;
    final startLabel = schedule.first['label'];
    final endLabel = schedule.last['label'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Periode: $startLabel - $endLabel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: DataTable(
                border: TableBorder.all(color: Colors.grey, width: 1),
                columnSpacing: 16,
                columns: const [
                  DataColumn(
                    label: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Angsuran',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sisa Hutang',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
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
                              'Rp ${_formatCurrencyDisplay((r['angsuran'] as num).toDouble().round())}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Rp ${_formatCurrencyDisplay((r['sisaHutang'] as num).toDouble().round())}',
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
  'terms_one',
  'terms_two',
  'terms_three',
  'terms_four',
  'terms_five',
  'terms_six',
  'terms_seven',
  'terms_eight',
  'terms_nine',
  'terms_ten',
  'terms_eleven',
  'terms_twelve',
];
