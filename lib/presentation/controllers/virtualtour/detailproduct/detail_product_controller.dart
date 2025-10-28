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

  // List gambar dari house model
  final RxList<String> images = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil house model dari arguments
    if (Get.arguments != null && Get.arguments is HouseModel) {
      houseModel.value = Get.arguments as HouseModel;
      images.value = houseModel.value?.gambar ?? [];
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

  // Toggle fullscreen mode
  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    // Reset zoom when exiting fullscreen
    if (!isFullscreen.value) {
      transformationController.value = Matrix4.identity();
    }
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
      );
    }
    // Tambahkan logic booking di sini
  }

  // Close modal
  void closeModal() {
    Get.back();
  }
}
