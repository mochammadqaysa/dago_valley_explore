class PromoTranslation {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String tag1;
  final String tag2;

  PromoTranslation({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.tag1,
    required this.tag2,
  });

  factory PromoTranslation.fromJson(Map<String, dynamic> json) =>
      PromoTranslation(
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        tag1: json["tag1"],
        tag2: json["tag2"],
      );
}
