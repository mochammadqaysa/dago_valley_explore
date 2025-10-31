import 'package:dago_valley_explore/data/models/promo_model.dart';
import 'package:dago_valley_explore/domain/entities/brochure.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';
import 'package:dago_valley_explore/domain/entities/housing.dart';
import 'package:dago_valley_explore/domain/entities/kpr_calculator.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:dago_valley_explore/domain/entities/site_plan.dart';

class HousingModel extends Housing {
  HousingModel({
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
  }) : super(
         id: id,
         name: name,
         alamat: alamat,
         logo: logo,
         createdAt: createdAt,
         updatedAt: updatedAt,
         promos: promos,
         events: events,
         brochures: brochures,
         siteplans: siteplans,
         kprCalculators: kprCalculators,
       );

  int? id;
  String? name;
  String? alamat;
  String? logo;
  String? createdAt;
  String? updatedAt;
  List<PromoModel>? promos;
  List<Event>? events;
  List<Brochure>? brochures;
  List<SitePlan>? siteplans;
  List<KprCalculator>? kprCalculators;

  factory HousingModel.fromJson(Map<String, dynamic> json) => HousingModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    alamat: json['alamat'] as String?,
    logo: json['logo'] as String?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    promos: (json['promos'] as List<dynamic>?)
        ?.map((e) => PromoModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    events: (json['events'] as List<dynamic>?)
        ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
        .toList(),
    brochures: (json['brochures'] as List<dynamic>?)
        ?.map((e) => Brochure.fromJson(e as Map<String, dynamic>))
        .toList(),
    siteplans: (json['siteplans'] as List<dynamic>?)
        ?.map((e) => SitePlan.fromJson(e as Map<String, dynamic>))
        .toList(),
    kprCalculators: (json['kprCalculators'] as List<dynamic>?)
        ?.map((e) => KprCalculator.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
  Map<String, dynamic> toJson() => <String, dynamic>{
    'author': instance.author,
    'title': instance.title,
    'description': instance.description,
    'url': instance.url,
    'urlToImage': instance.urlToImage,
    'publishedAt': instance.publishedAt?.toIso8601String(),
    'content': instance.content,
  };
}
