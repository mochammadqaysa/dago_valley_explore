class Promo {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String tag1;
  final String tag2;
  Promo? en;

  Promo({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.tag1,
    required this.tag2,
    this.en,
  });
}
