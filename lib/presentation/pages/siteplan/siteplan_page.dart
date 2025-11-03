import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/detailsiteplan/detail_siteplan_binding.dart';
import 'package:dago_valley_explore/presentation/pages/qrcode/qrcode_page.dart';
import 'package:dago_valley_explore/presentation/pages/siteplan/detail_siteplan/detail_siteplan_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
        // Assuming LocalStorageService has a 'brochures' getter returning List<Brochure>?
        // Adjust field name if your implementation uses a different property.
        final brochures = storage.brochures;
        print('Fetched brochures from local storage: $brochures');
        if (brochures != null && brochures.isNotEmpty) {
          final first = brochures.first;
          // Brochure entity should have imageUrl property; adjust if different
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

    // Navigate to QRCodePage and pass the url via arguments; binding will create controller with this arg
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
    final bg = const Color(0xFF121212);

    return Scaffold(
      // backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 900 : 600),
              child: Card(
                // color: const Color(0xFF1B1B1B),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 36,
                    horizontal: 28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: isWide ? 120 : 88,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Fitur Siteplan',
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: isWide ? 28 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Fitur peta/siteplan sedang kami kembangkan. '
                        'Segera hadir: tampilan interaktif, zoom, dan detail unit.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // color: Colors.white70,
                          fontSize: isWide ? 16 : 14,
                        ),
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
                            // Optional: open a help page or send feedback
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // panggil tanpa arg -> ambil dari localstorage
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.map, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
