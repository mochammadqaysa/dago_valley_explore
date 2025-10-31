import 'package:dago_valley_explore/domain/entities/promo_translation.dart';

class Promo {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String tag1;
  final String tag2;
  final PromoTranslation en;

  Promo({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.tag1,
    required this.tag2,
    required this.en,
  });
}

// final List<Promo> dummyPromos = [
//   Promo(
//     title: 'Miliki Kavling Impian di Lokasi Paling Dicari di Bandung!',
//     subtitle: 'Hemat Hingga 50%',
//     description:
//         '''Tersedia 2 unit terakhir di Perumahan Eksklusif Dago Valley, Dago, Bandung – sebuah lokasi yang tak hanya menawarkan lingkungan alam yang indah, tetapi juga nilai investasi yang terus meningkat. Ini adalah kesempatan langka untuk membangun rumah impian Anda di lingkungan yang nyaman dan prestisius. 
// Harga Promo Istimewa Hanya Sampai Akhir 30 Mei 2024!
// Jangan Tunda Lagi! 
// Hubungi kami sekarang untuk informasi lebih lanjut.''',
//     imageUrl: 'assets/promo/promo1.jpg',
//     tag1: 'Open House',
//     tag2: 'Hemat',
//   ),
//   Promo(
//     title: 'Temukan kenyamanan dan kemewahan hidup di Dago Valley, Bandung.',
//     subtitle:
//         'kawasan hunian eksklusif dengan suasana hijau dan udara sejuk khas Dago',
//     description:
//         '''Temukan kenyamanan dan kemewahan hidup di Dago Valley, Bandung — kawasan hunian eksklusif dengan suasana hijau dan udara sejuk khas Dago.
// Kini, setiap pembelian unit rumah di Dago Valley semakin istimewa!
// Nikmati Bonus Kitchen Set senilai 50 juta rupiah untuk melengkapi rumah impian Anda.
// Hunian modern dengan desain elegan, lokasi strategis, dan lingkungan yang asri — sempurna untuk keluarga yang mendambakan kualitas hidup lebih baik.
// 🎁 Promo terbatas!
// Segera amankan unit pilihan Anda sebelum promo berakhir.''',
//     imageUrl: 'assets/promo/promo2.jpg',
//     tag1: 'Akhir Tahun',
//     tag2: 'Hemat',
//   ),
//   Promo(
//     title: 'Rasakan kesejukan dan ketenangan hidup di Dago Valley, Bandung,',
//     subtitle: 'hanya beberapa menit dari pusat kota.',
//     description:
//         '''Persembahan terbaru kami, Harmony Type 76/108, menawarkan desain rumah modern dengan kenyamanan maksimal bagi keluarga Anda.
// Kini tersedia dengan harga spesial mulai dari 1,9 M (all in) — termasuk Free BPHTB dan PPN, serta potongan harga hingga ratusan juta rupiah.
// Inilah kesempatan terbaik untuk memiliki hunian premium dengan lingkungan alami yang menenangkan.
// Hidup lebih sehat, lebih tenang, dan lebih dekat dengan alam — hanya di Dago Valley.''',
//     imageUrl: 'assets/promo/promo3.jpg',
//     tag1: 'Akhir Tahun',
//     tag2: 'Hemat',
//   ),
// ];

// final List<Promo> dummyEvents = [
//   Promo(
//     title: 'Miliki Kavling Impian di Lokasi Paling Dicari di Bandung!',
//     subtitle: 'Hemat Hingga 50%',
//     description:
//         '''Tersedia 2 unit terakhir di Perumahan Eksklusif Dago Valley, Dago, Bandung – sebuah lokasi yang tak hanya menawarkan lingkungan alam yang indah, tetapi juga nilai investasi yang terus meningkat. Ini adalah kesempatan langka untuk membangun rumah impian Anda di lingkungan yang nyaman dan prestisius. 
// Harga Promo Istimewa Hanya Sampai Akhir 30 Mei 2024!
// Jangan Tunda Lagi! 
// Hubungi kami sekarang untuk informasi lebih lanjut.''',
//     imageUrl: 'assets/event/openhouse1.jpg',
//     tag1: 'Open House',
//     tag2: 'Hemat',
//   ),
//   Promo(
//     title: 'Temukan kenyamanan dan kemewahan hidup di Dago Valley, Bandung.',
//     subtitle:
//         'kawasan hunian eksklusif dengan suasana hijau dan udara sejuk khas Dago',
//     description:
//         '''Temukan kenyamanan dan kemewahan hidup di Dago Valley, Bandung — kawasan hunian eksklusif dengan suasana hijau dan udara sejuk khas Dago.
// Kini, setiap pembelian unit rumah di Dago Valley semakin istimewa!
// Nikmati Bonus Kitchen Set senilai 50 juta rupiah untuk melengkapi rumah impian Anda.
// Hunian modern dengan desain elegan, lokasi strategis, dan lingkungan yang asri — sempurna untuk keluarga yang mendambakan kualitas hidup lebih baik.
// 🎁 Promo terbatas!
// Segera amankan unit pilihan Anda sebelum promo berakhir.''',
//     imageUrl: 'assets/event/openhouse2.jpg',
//     tag1: 'Akhir Tahun',
//     tag2: 'Hemat',
//   ),
//   Promo(
//     title: 'Rasakan kesejukan dan ketenangan hidup di Dago Valley, Bandung,',
//     subtitle: 'hanya beberapa menit dari pusat kota.',
//     description:
//         '''Persembahan terbaru kami, Harmony Type 76/108, menawarkan desain rumah modern dengan kenyamanan maksimal bagi keluarga Anda.
// Kini tersedia dengan harga spesial mulai dari 1,9 M (all in) — termasuk Free BPHTB dan PPN, serta potongan harga hingga ratusan juta rupiah.
// Inilah kesempatan terbaik untuk memiliki hunian premium dengan lingkungan alami yang menenangkan.
// Hidup lebih sehat, lebih tenang, dan lebih dekat dengan alam — hanya di Dago Valley.''',
//     imageUrl: 'assets/event/openhouse3.jpg',
//     tag1: 'Akhir Tahun',
//     tag2: 'Hemat',
//   ),
// ];
