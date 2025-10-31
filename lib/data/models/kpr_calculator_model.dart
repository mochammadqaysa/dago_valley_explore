import 'package:dago_valley_explore/domain/entities/kpr_calculator.dart';

class KprCalculatorModel extends KprCalculator {
  KprCalculatorModel({
    required this.id,
    required this.housingId,
    required this.marginDeveloper,
    required this.dpDeveloper,
    required this.dpSyariah,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
         id: id,
         housingId: housingId,
         marginDeveloper: marginDeveloper,
         dpDeveloper: dpDeveloper,
         dpSyariah: dpSyariah,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  final int id;
  final String housingId;
  final String marginDeveloper;
  final String dpDeveloper;
  final String dpSyariah;
  final String createdAt;
  final String updatedAt;

  @override
  factory KprCalculatorModel.fromJson(Map<String, dynamic> json) =>
      KprCalculatorModel(
        id: json["id"],
        housingId: json["housing_id"],
        marginDeveloper: json["margin_developer"],
        dpDeveloper: json["dp_developer"],
        dpSyariah: json["dp_syariah"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}
