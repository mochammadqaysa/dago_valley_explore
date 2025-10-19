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
    fetchPromos();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fetch data promo (bisa diganti dengan API call)
  void fetchPromos() {
    _promos.value = [
      Promo(
        title: 'Open House\nDago Valley',
        subtitle: 'Sabtu-Minggu, 31 Mei - 1 Juni 2025',
        description:
            'Lorem ipsum dolor sit amet consectetur adipiscing elit, quisque venenatis dis vulputate facilisi lectus proin, varius at auctor sociis. Jangan lewatkan kesempatan emas ini untuk memiliki hunian impian Anda di Dago Valley!',
        imageUrl: 'assets/1.png',
        tag1: 'GRATIS 3 UNIT AC*',
        tag2: 'RATUSAN JUTA RUPIAH',
      ),
      Promo(
        title: 'Promo Spesial\nLebaran 2025',
        subtitle: 'Periode: 1-30 April 2025',
        description:
            'Dapatkan diskon hingga ratusan juta rupiah untuk pembelian unit terpilih. Promo terbatas hanya untuk 10 pembeli pertama!',
        imageUrl: 'assets/1.png',
        tag1: 'DISKON 20%',
        tag2: 'FREE KPR',
      ),
      Promo(
        title: 'Grand Opening\nShow Unit',
        subtitle: 'Setiap Weekend Mei 2025',
        description:
            'Kunjungi show unit kami dan rasakan langsung kenyamanan hunian di Dago Valley. Konsultasi gratis dengan team marketing kami.',
        imageUrl: 'assets/1.png',
        tag1: 'FREE CANOPY',
        tag2: 'BONUS FURNITURE',
      ),
    ];
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
