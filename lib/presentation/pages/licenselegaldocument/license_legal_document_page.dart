import 'dart:convert';
import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
    // Langsung navigate dengan loading di dalam PdfViewerPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(
          assetPath: 'assets/legalitas/$assetPath',
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTV = MediaQuery.of(context).size.width > 800;
    final crossAxisCount = isTV ? 5 : 1;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
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

class PdfViewerPage extends StatefulWidget {
  final String assetPath;
  final String title;

  const PdfViewerPage({Key? key, required this.assetPath, required this.title})
    : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      // Delay sebentar agar UI tidak freeze
      await Future.delayed(const Duration(milliseconds: 100));

      // Untuk web, pastikan asset sudah ready
      if (kIsWeb) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat PDF: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title.replaceAll('.pdf', '').toUpperCase()),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (!_isLoading && _error == null)
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () {
                _pdfViewerController.zoomLevel =
                    _pdfViewerController.zoomLevel + 0.25;
              },
            ),
          if (!_isLoading && _error == null)
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () {
                _pdfViewerController.zoomLevel =
                    _pdfViewerController.zoomLevel - 0.25;
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Memuat PDF...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            )
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            )
          : SfPdfViewer.asset(
              widget.assetPath,
              controller: _pdfViewerController,
              enableDoubleTapZooming: true,
              enableTextSelection: true,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                setState(() {
                  _error = 'Gagal memuat dokumen: ${details.error}';
                });
              },
            ),
    );
  }
}
