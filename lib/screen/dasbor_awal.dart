import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/presentation/components/glass/glassy_button.dart';
import 'package:dago_valley_explore/screen/site_plan.dart';
import 'package:flutter/material.dart';

class DasborAwal extends StatefulWidget {
  const DasborAwal({super.key});

  @override
  State<DasborAwal> createState() => _DasborAwalState();
}

class _DasborAwalState extends State<DasborAwal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("F4F4F4"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  height: 450,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  clipBehavior: Clip.antiAlias, // agar borderRadius bekerja
                  child: Stack(
                    children: [
                      // Gambar
                      Image.asset(
                        "assets/1.jpg",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      // Overlay hitam
                      Container(color: Colors.black.withOpacity(0.5)),
                      // Text di atas overlay
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Lorem Ipsum Dolor Sit Amet",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            GlassyButton(
                              onPressed: () {},
                              child: Text("Glassy Button"),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors
                                    .primary, // ganti dengan warna yang Anda inginkan
                                foregroundColor: Colors.white, // warna text
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Lihat Promo",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Tambahkan ini
                    children: [
                      SitePlanCard(
                        title: 'Site Plan',
                        imageUrl: 'assets/1.jpg',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Button pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                      SitePlanCard(
                        title: 'Site Plan',
                        imageUrl: 'assets/1.jpg',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Button pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                      SitePlanCard(
                        title: 'Site Plan',
                        imageUrl: 'assets/1.jpg',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Button pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                      SitePlanCard(
                        title: 'Site Plan',
                        imageUrl: 'assets/1.jpg',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Button pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
