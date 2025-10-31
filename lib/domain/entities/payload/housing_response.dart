import 'package:dago_valley_explore/domain/entities/housing.dart';
import 'package:dago_valley_explore/domain/entities/versions.dart';

class HousingResponse {
  final List<Housing> housing;
  final Versions versions;

  HousingResponse({required this.housing, required this.versions});
}
