import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class LicenseLegalDocumentPage extends StatefulWidget {
  const LicenseLegalDocumentPage({Key? key}) : super(key: key);

  @override
  State<LicenseLegalDocumentPage> createState() =>
      _LicenseLegalDocumentPageState();
}

class _LicenseLegalDocumentPageState extends State<LicenseLegalDocumentPage> {
  List<String> pdfFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPdfList();
  }

  Future<void> loadPdfList() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final pdfPaths = manifestMap.keys
        .where(
          (String key) =>
              key.startsWith('assets/legalitas/') && key.endsWith('.pdf'),
        )
        .toList();

    setState(() {
      pdfFiles = pdfPaths.map((e) => e.split('/').last).toList();
      isLoading = false;
    });
  }

  Future<void> openPdf(String assetPath, String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      final ByteData bytes = await rootBundle.load(
        'assets/legalitas/$assetPath',
      );
      final Uint8List list = bytes.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$assetPath');
      await file.writeAsBytes(list, flush: true);

      if (!mounted) return;
      Navigator.pop(context); // tutup loading
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerPage(path: file.path, title: title),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      print('Error membuka PDF: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuka PDF: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTV = MediaQuery.of(context).size.width > 800;
    final crossAxisCount = isTV ? 5 : 1;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dokumentasi Perizinan dan Legalitas '),

      //   titleTextStyle: const TextStyle(
      //     color: themeController.isDarkMode ? Colors.white : Colors.grey,
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: isTV ? 1.1 : 2.5,
              ),
              itemCount: pdfFiles.length,
              itemBuilder: (context, index) {
                final fileName = pdfFiles[index];
                return GestureDetector(
                  onTap: () => openPdf(fileName, fileName),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode
                            ? Colors.grey[900]
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: themeController.isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: themeController.isDarkMode
                                ? Colors.black.withOpacity(0.4)
                                : Colors.grey.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _PdfFileIcon(),
                          const SizedBox(height: 12),
                          Text(
                            fileName.replaceAll('.pdf', '').toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: isTV ? 18 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// Widget ikon seperti berkas dengan tulisan "PDF"
class _PdfFileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.insert_drive_file, size: 90, color: Colors.grey.shade600),
        Positioned(
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PDF',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String path;
  final String title;

  const PdfViewerPage({Key? key, required this.path, required this.title})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title.replaceAll('.pdf', '').toUpperCase()),
        backgroundColor: Colors.black,
      ),
      body: PDFView(
        filePath: path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
      ),
    );
  }
}
