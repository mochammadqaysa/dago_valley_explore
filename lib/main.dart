import 'dart:math' as math show pi;

import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:dago_valley_explore/app/config/app_colors.dart';
import 'package:dago_valley_explore/screen/example_screen_1.dart';
import 'package:dago_valley_explore/screen/example_screen_2.dart';
import 'package:dago_valley_explore/screen/example_screen_3.dart';
import 'package:dago_valley_explore/sidebar.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sidebar ui',
      home: Scaffold(
        body: SidebarPage(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: const Text('Yay! Button Pressed!')),
        //     );
        //   },
        //   backgroundColor: Colors.green,
        //   child: const Icon(Icons.navigation),
        // ),
      ),
    );
  }
}
