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

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    housingId: json["housing_id"],
    title: json["title"],
    subtitle: json["subtitle"],
    description: json["description"],
    imageUrl: json["image_url"],
    tag1: json["tag1"],
    tag2: json["tag2"],
    en: PromoTranslation.fromJson(json["en"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "housing_id": housingId,
    "title": title,
    "subtitle": subtitle,
    "description": description,
    "image_url": imageUrl,
    "tag1": tag1,
    "tag2": tag2,
    "en": en.toJson(),
  };
}
