import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/detailsiteplan/detail_siteplan_binding.dart';
import 'package:dago_valley_explore/presentation/pages/qrcode/qrcode_page.dart';
import 'package:dago_valley_explore/presentation/pages/siteplan/detail_siteplan/detail_siteplan_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SiteplanPage extends StatefulWidget {
  const SiteplanPage({Key? key}) : super(key: key);

  @override
  State<SiteplanPage> createState() => _SiteplanPageState();
}

class _SiteplanPageState extends State<SiteplanPage> {
  void _showNotifySnack() {
    Get.snackbar(
      'Terima Kasih',
      'Kami akan memberi tahu Anda saat fitur Siteplan tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void _showSitePlanModal([String? url]) {
    // If caller didn't pass URL, try get from local storage (Brochure list)
    if (url == null || url.isEmpty) {
      try {
        final storage = Get.find<LocalStorageService>();
        // Adjust property name if your LocalStorageService uses a different field.
        final brochures = storage.brochures;
        if (kDebugMode)
          print('Fetched brochures from local storage: $brochures');
        if (brochures != null && brochures.isNotEmpty) {
          final first = brochures.first;
          url = (first.imageUrl ?? '').toString();
        }
      } catch (e) {
        if (kDebugMode)
          print('Error fetching brochures from local storage: $e');
      }
    }

    if (url == null || url.isEmpty) {
      Get.snackbar(
        'QR Code',
        'Tidak ada URL brochure yang tersedia.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Debug log
    if (kDebugMode) print('Opening Siteplan detail modal with url: $url');

    // Navigate to SiteplanDetailPage and pass the url via arguments; binding will create controller with this arg
    Get.to(
      () => const SiteplanDetailPage(),
      binding: DetailSiteplanBinding(),
      arguments: url,
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 900 : 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset("assets/time.svg", colorFilter: null),
                    const SizedBox(height: 20),
                    Text(
                      'siteplan_feature'.tr,
                      style: TextStyle(
                        fontSize: isWide ? 28 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'siteplan_feature_desc'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: isWide ? 16 : 14),
                    ),
                    const SizedBox(height: 24),
                    Visibility(
                      visible: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white70,
                            ),
                            label: const Text('Kembali'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _showNotifySnack,
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                            label: const Text('Beritahu Saya'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Visibility(
                      visible: false,
                      child: TextButton(
                        onPressed: () {
                          Get.snackbar(
                            'Info',
                            'Ingin fitur ini lebih cepat? Kirimkan masukan melalui halaman kontak.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                          );
                        },
                        child: Text(
                          'Butuh fitur khusus? Kirim masukan →',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSitePlanModal(), // <-- call the function
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.map, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
