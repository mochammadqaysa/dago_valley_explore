import 'package:dago_valley_explore/domain/entities/brochure.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';
import 'package:dago_valley_explore/domain/entities/kpr_calculator.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:dago_valley_explore/domain/entities/site_plan.dart';

class Housing {
  int? id;
  String? name;
  String? alamat;
  String? logo;
  String? createdAt;
  String? updatedAt;
  List<Promo>? promos;
  List<Event>? events;
  List<Brochure>? brochures;
  List<SitePlan>? siteplans;
  List<KprCalculator>? kprCalculators;

  Housing({
    this.id,
    this.name,
    this.alamat,
    this.logo,
    this.createdAt,
    this.updatedAt,
    this.promos,
    this.events,
    this.brochures,
    this.siteplans,
    this.kprCalculators,
  });
}
