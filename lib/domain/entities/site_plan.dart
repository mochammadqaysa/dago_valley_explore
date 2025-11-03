class SitePlan {
  final int id;
  final String housingId;
  final String name;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  SitePlan({
    required this.id,
    required this.housingId,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SitePlan.fromJson(Map<String, dynamic> json) => SitePlan(
    id: json["id"],
    housingId: json["housing_id"],
    name: json['name'],
    imageUrl: json['imageUrl'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "housing_id": housingId,
    "name": name,
    "imageUrl": imageUrl,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
