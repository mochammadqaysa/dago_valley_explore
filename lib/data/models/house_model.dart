// lib/house_model.dart
class HouseModel {
  final String type;
  final String model;
  final List<String> blok;
  final int jumlahUnit;
  final int hargaCash;

  const HouseModel({
    required this.type,
    required this.model,
    required this.blok,
    required this.jumlahUnit,
    required this.hargaCash,
  });

  String get displayName => "$model ($type)";
}

const List<HouseModel> houseModels = [
  HouseModel(
    type: "100/108",
    model: "Harmoni",
    blok: ["I3", "I5", "I7", "I8"],
    jumlahUnit: 4,
    hargaCash: 2499000000,
  ),
  HouseModel(
    type: "106/112",
    model: "Harmoni",
    blok: ["G3", "G5", "G7"],
    jumlahUnit: 3,
    hargaCash: 2670000000,
  ),
  HouseModel(
    type: "112/117",
    model: "Harmoni",
    blok: ["F3", "F5"],
    jumlahUnit: 2,
    hargaCash: 2820000000,
  ),
  HouseModel(
    type: "129/144",
    model: "Harmoni",
    blok: ["H1", "H2", "H9", "H10", "I2", "I9", "I10"],
    jumlahUnit: 7,
    hargaCash: 3333000000,
  ),
  HouseModel(
    type: "131/150",
    model: "Harmoni",
    blok: ["G1", "G9"],
    jumlahUnit: 2,
    hargaCash: 3443000000,
  ),
  HouseModel(
    type: "131/169",
    model: "Harmoni",
    blok: ["F1", "F7"],
    jumlahUnit: 2,
    hargaCash: 3787000000,
  ),
  HouseModel(
    type: "144/190",
    model: "Foresta",
    blok: ["E3", "E5"],
    jumlahUnit: 2,
    hargaCash: 4351000000,
  ),
  HouseModel(
    type: "200/186",
    model: "Foresta",
    blok: ["F6", "F8"],
    jumlahUnit: 2,
    hargaCash: 4799000000,
  ),
  HouseModel(
    type: "144/228",
    model: "Foresta",
    blok: ["F4"],
    jumlahUnit: 1,
    hargaCash: 4957000000,
  ),
  HouseModel(
    type: "193/228",
    model: "Foresta",
    blok: ["E1", "E7"],
    jumlahUnit: 2,
    hargaCash: 5311000000,
  ),
  HouseModel(
    type: "193/235",
    model: "Foresta",
    blok: ["F2"],
    jumlahUnit: 1,
    hargaCash: 5422000000,
  ),
];
