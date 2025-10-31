import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:get/get.dart';

class PromoController extends GetxController {
  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // List promo (bisa diganti dengan API call)
  final _promos = <Promo>[].obs;
  List<Promo> get promos => dummyPromos;

  // Current promo
  Promo get currentPromo => dummyPromos[_currentIndex.value];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Set index carousel
  void setCurrentIndex(int index) {
    _currentIndex.value = index;
  }

  // Go to specific page
  void goToPage(int index) {
    carouselController.animateToPage(index);
  }

  // Handle booking action
  void bookPromo() {
    Get.snackbar(
      'Booking',
      'Booking promo: ${currentPromo.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Tambahkan logic booking di sini
  }

  // Close modal
  void closeModal() {
    Get.back();
  }
}
