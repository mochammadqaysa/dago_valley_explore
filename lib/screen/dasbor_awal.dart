import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_button.dart';
import 'package:dago_valley_explore/presentation/components/liquidglass/liquid_glass_container.dart';
import 'package:dago_valley_explore/screen/site_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oc_liquid_glass/oc_liquid_glass.dart';

class DasborAwal extends StatefulWidget {
  const DasborAwal({super.key});

  @override
  State<DasborAwal> createState() => _DasborAwalState();
}

class _DasborAwalState extends State<DasborAwal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: HexColor("F4F4F4"),
      backgroundColor: HexColor("121212"),
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
                        "assets/1.png",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fitWidth,
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
                            LiquidGlassButton(
                              width: 200,
                              borderRadius: 30,
                              text: 'Lihat Promo',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 40, // jarak antar kartu
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      SitePlanCard(
                        title: 'Site Plan',
                        imageUrl: 'assets/1.png',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Button pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                      SitePlanCard(
                        title: 'Event',
                        imageUrl: 'assets/1.png',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Button pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                      SitePlanCard(
                        title: 'Tipe Rumah',
                        imageUrl: 'assets/1.png',
                        buttonText: 'Check',
                        onButtonPressed: () {
                          print('Button pressed!');
                        },
                        titleBackgroundColor: Colors.white,
                        buttonColor: Colors.white,
                      ),
                      SitePlanCard(
                        title: 'Akad',
                        imageUrl: 'assets/1.png',
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
                SizedBox(height: 16),
                LiquidGlassContainer(
                  glassColor: Colors.black,
                  glassAccentColor: Colors.black,
                  height: 60,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/whatsapp.svg",
                            color: Colors.white,
                          ),
                        ],
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
