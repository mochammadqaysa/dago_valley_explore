import 'package:dago_valley_explore/domain/entities/site_plan.dart';

class SitePlanModel extends SitePlan {
  SitePlanModel({
    required this.id,
    required this.housingId,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
         id: id,
         housingId: housingId,
         name: name,
         imageUrl: imageUrl,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  final int id;
  final String housingId;
  final String name;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  @override
  factory SitePlanModel.fromJson(Map<String, dynamic> json) => SitePlanModel(
    id: json["id"],
    housingId: json["housing_id"],
    name: json["name"],
    imageUrl: json["imageUrl"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );
}
