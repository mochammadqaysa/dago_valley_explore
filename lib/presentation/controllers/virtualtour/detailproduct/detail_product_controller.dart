import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/data/models/house_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final currentIndex = 0.obs;

  // Observable untuk fullscreen mode
  final isFullscreen = false.obs;

  // TransformationController untuk zoom
  final transformationController = TransformationController();

  // House model yang akan ditampilkan
  final Rx<HouseModel?> houseModel = Rx<HouseModel?>(null);

  // List gambar dan video dari house model
  final RxList<String> images = <String>[].obs;
  final RxList<String> videos = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil house model dari arguments
    if (Get.arguments != null && Get.arguments is HouseModel) {
      houseModel.value = Get.arguments as HouseModel;
      images.value = houseModel.value?.gambar ?? [];
      videos.value = houseModel.value?.video ?? [];

      print('📊 Product Detail Loaded:');
      print('   Model: ${houseModel.value?.model}');
      print('   Type: ${houseModel.value?.type}');
      print('   Images: ${images.length}');
      print('   Videos: ${videos.length} (not implemented yet)');
    }
  }

  @override
  void onClose() {
    transformationController.dispose();
    super.onClose();
  }

  // Set index carousel
  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  // Go to specific page
  void goToPage(int index) {
    carouselController.animateToPage(index);
  }

  // Open fullscreen
  void openFullscreen() {
    isFullscreen.value = true;
  }

  // Close fullscreen
  void closeFullscreen() {
    isFullscreen.value = false;
    transformationController.value = Matrix4.identity();
  }

  // Handle booking action
  void bookPromo() {
    if (houseModel.value != null) {
      Get.snackbar(
        'Booking',
        'Booking untuk ${houseModel.value!.model}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Close modal
  void closeModal() {
    Get.back();
  }
}
