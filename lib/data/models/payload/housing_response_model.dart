import 'package:dago_valley_explore/domain/entities/housing.dart';
import 'package:dago_valley_explore/domain/entities/payload/housing_response.dart';
import 'package:dago_valley_explore/domain/entities/versions.dart';

class HousingResponseModel extends HousingResponse {
  HousingResponseModel({required this.housing, required this.versions})
    : super(housing: housing, versions: versions);

  final List<Housing> housing;
  final Versions versions;

  @override
  factory HousingResponseModel.fromJson(Map<String, dynamic> json) =>
      HousingResponseModel(
        housing: List.from(json["housing"].map((x) => Housing.fromJson(x))),
        versions: Versions.fromJson(json["versions"]),
      );
}
