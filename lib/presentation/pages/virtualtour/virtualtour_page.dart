import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail/detail_page.dart';

class VirtualtourPage extends StatelessWidget {
  const VirtualtourPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // ✅ Warna benar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // ========== SECTION HARMONI ==========
              _buildSectionHeader(
                title: 'Harmoni',
                subtitle: 'Hunian nyaman dengan desain modern tropis',
                themeController: themeController,
              ),
              const SizedBox(height: 20),
              _buildHorizontalHouseList(
                useAspectRatio: true,
                modelFilter: 'Harmoni',
              ),

              const SizedBox(height: 40),

              // ========== SECTION FORESTA ==========
              _buildSectionHeader(
                title: 'Foresta',
                subtitle: 'Keseimbangan kemewahan dan keharmonisan alam',
                themeController: themeController,
              ),
              const SizedBox(height: 20),
              _buildHorizontalHouseList(
                useAspectRatio: true,
                modelFilter: 'Foresta',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Widget Header Reusable =====
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required ThemeController themeController,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.only(left: 16),
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
                width: 2,
              ),
            ),
          ),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 18), // ✅ Lebih proporsional
          ),
        ),
      ],
    );
  }

  // ===== Widget Horizontal List Reusable =====
  Widget _buildHorizontalHouseList({
    bool useAspectRatio = false,
    String modelFilter = 'Harmoni',
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: houseModels.where((house) => house.model == modelFilter).map((
          house,
        ) {
          // Faktor skala (misal 2x)
          final double scaleFactor = useAspectRatio ? 1.5 : 1.0;
          final double baseWidth = 181;
          final double baseHeight = 242;

          return GestureDetector(
            onTap: () {
              // Get.to(() => DetailPage(houseModel: house));
            },
            child: Container(
              width: baseWidth * scaleFactor,
              height: baseHeight * scaleFactor,
              margin: const EdgeInsets.only(right: 16),
              child: _buildHouseCard(house),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===== Widget Kartu Rumah =====
  Widget _buildHouseCard(HouseModel house) {
    return Container(
      margin: const EdgeInsets.only(right: 35),
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(house.gambar.first),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
