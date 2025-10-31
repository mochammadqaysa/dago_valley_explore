import 'package:dago_valley_explore/domain/entities/promo_translation.dart';

class Event {
  final int id;
  final String housingId;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String tag1;
  final String tag2;
  final PromoTranslation en;

  Event({
    required this.id,
    required this.housingId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.tag1,
    required this.tag2,
    required this.en,
  });
}
