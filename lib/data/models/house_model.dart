// lib/data/models/house_model.dart

class HouseModel {
  final String type;
  final String model;
  final List<String> blok;
  final int jumlahUnit;
  final int hargaCash;

  /// Struktur:
  /// {
  ///   "kpr_syariah": {5: {"cicilan": int, "total": int}, ...},
  ///   "developer_dp": {1: {"cicilan": int, "total": int}, ...},
  ///   "developer_tanpa_dp": {1: {"cicilan": int, "total": int}, ...},
  /// }
  final Map<String, Map<int, Map<String, int>>> cicilanData;

  const HouseModel({
    required this.type,
    required this.model,
    required this.blok,
    required this.jumlahUnit,
    required this.hargaCash,
    required this.cicilanData,
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
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 42467256, "total": 3047835335},
        10: {"cicilan": 26408506, "total": 3668820708},
        15: {"cicilan": 21471277, "total": 4364629789},
        20: {"cicilan": 19279469, "total": 5126872558},
      },
      "developer_dp": {
        1: {"cicilan": 153428188, "total": 2590838250},
        2: {"cicilan": 80540688, "total": 2682676500},
        3: {"cicilan": 56244854, "total": 2774514750},
        4: {"cicilan": 44096938, "total": 2866353000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 219183125, "total": 2630197500},
        2: {"cicilan": 115058125, "total": 2761395000},
        3: {"cicilan": 80349792, "total": 2892592500},
        4: {"cicilan": 62995625, "total": 3023790000},
      },
    },
  ),
  HouseModel(
    type: "106/112",
    model: "Harmoni",
    blok: ["G3", "G5", "G7"],
    jumlahUnit: 3,
    hargaCash: 2670000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 45373178, "total": 3256390694},
        10: {"cicilan": 28215571, "total": 3919868463},
        15: {"cicilan": 22940500, "total": 4663289931},
        20: {"cicilan": 20598712, "total": 5477690969},
      },
      "developer_dp": {
        1: {"cicilan": 163926875, "total": 2768122500},
        2: {"cicilan": 86051875, "total": 2866245000},
        3: {"cicilan": 60093542, "total": 2964367500},
        4: {"cicilan": 47114375, "total": 3062490000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 234181250, "total": 2810175000},
        2: {"cicilan": 122931250, "total": 2950350000},
        3: {"cicilan": 85847917, "total": 3090525000},
        4: {"cicilan": 67306250, "total": 3230700000},
      },
    },
  ),
  HouseModel(
    type: "112/117",
    model: "Harmoni",
    blok: ["F3", "F5"],
    jumlahUnit: 2,
    hargaCash: 2820000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 47922233, "total": 3439333991},
        10: {"cicilan": 29800715, "total": 4140085793},
        15: {"cicilan": 24229292, "total": 4925272511},
        20: {"cicilan": 21755943, "total": 5785426416},
      },
      "developer_dp": {
        1: {"cicilan": 173136250, "total": 2923635000},
        2: {"cicilan": 90886250, "total": 3027270000},
        3: {"cicilan": 63469583, "total": 3130905000},
        4: {"cicilan": 49761250, "total": 3234540000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 247337500, "total": 2968050000},
        2: {"cicilan": 129837500, "total": 3116100000},
        3: {"cicilan": 90670833, "total": 3264150000},
        4: {"cicilan": 71087500, "total": 3412200000},
      },
    },
  ),
  HouseModel(
    type: "129/144",
    model: "Harmoni",
    blok: ["H1", "H2", "H9", "H10", "I2", "I9", "I10"],
    jumlahUnit: 7,
    hargaCash: 3333000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 56640001, "total": 4065000068},
        10: {"cicilan": 35221909, "total": 4893229059},
        15: {"cicilan": 28636961, "total": 5821252936},
        20: {"cicilan": 25713674, "total": 6837881648},
      },
      "developer_dp": {
        1: {"cicilan": 204632313, "total": 3455487750},
        2: {"cicilan": 107419813, "total": 3577975500},
        3: {"cicilan": 75015646, "total": 3700463250},
        4: {"cicilan": 58813563, "total": 3822951000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 292331875, "total": 3507982500},
        2: {"cicilan": 153456875, "total": 3682965000},
        3: {"cicilan": 107165208, "total": 3857947500},
        4: {"cicilan": 84019375, "total": 4032930000},
      },
    },
  ),
  HouseModel(
    type: "131/150",
    model: "Harmoni",
    blok: ["G1", "G9"],
    jumlahUnit: 2,
    hargaCash: 3443000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 58509308, "total": 4199158486},
        10: {"cicilan": 36384348, "total": 5054721767},
        15: {"cicilan": 29582075, "total": 6013373495},
        20: {"cicilan": 26562310, "total": 7063554309},
      },
      "developer_dp": {
        1: {"cicilan": 211385854, "total": 3569530250},
        2: {"cicilan": 110965021, "total": 3696060500},
        3: {"cicilan": 77491410, "total": 3822590750},
        4: {"cicilan": 60754604, "total": 3949121000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 301979792, "total": 3623757500},
        2: {"cicilan": 158521458, "total": 3804515000},
        3: {"cicilan": 110702014, "total": 3985272500},
        4: {"cicilan": 86792292, "total": 4166030000},
      },
    },
  ),
  HouseModel(
    type: "131/169",
    model: "Harmoni",
    blok: ["F1", "F7"],
    jumlahUnit: 2,
    hargaCash: 3787000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 64355141, "total": 4618708448},
        10: {"cicilan": 40019613, "total": 5559753510},
        15: {"cicilan": 32537705, "total": 6614186880},
        20: {"cicilan": 29216226, "total": 7769294269},
      },
      "developer_dp": {
        1: {"cicilan": 232506021, "total": 3926172250},
        2: {"cicilan": 122051854, "total": 4065344500},
        3: {"cicilan": 85233799, "total": 4204516750},
        4: {"cicilan": 66824771, "total": 4343689000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 332151458, "total": 3985817500},
        2: {"cicilan": 174359792, "total": 4184635000},
        3: {"cicilan": 121762569, "total": 4383452500},
        4: {"cicilan": 95463958, "total": 4582270000},
      },
    },
  ),
  HouseModel(
    type: "144/190",
    model: "Foresta",
    blok: ["E3", "E5"],
    jumlahUnit: 2,
    hargaCash: 4351000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 73939587, "total": 5306575246},
        10: {"cicilan": 45979756, "total": 6387770668},
        15: {"cicilan": 37383563, "total": 7599241382},
        20: {"cicilan": 33567415, "total": 8926379552},
      },
      "developer_dp": {
        1: {"cicilan": 267133271, "total": 4510899250},
        2: {"cicilan": 140229104, "total": 4670798500},
        3: {"cicilan": 97927715, "total": 4830697750},
        4: {"cicilan": 76777021, "total": 4990597000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 381618958, "total": 4579427500},
        2: {"cicilan": 200327292, "total": 4807855000},
        3: {"cicilan": 139896736, "total": 5036282500},
        4: {"cicilan": 109681458, "total": 5264710000},
      },
    },
  ),
  HouseModel(
    type: "200/186",
    model: "Foresta",
    blok: ["F6", "F8"],
    jumlahUnit: 2,
    hargaCash: 4799000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 81552765, "total": 5852965895},
        10: {"cicilan": 50714054, "total": 7045486425},
        15: {"cicilan": 41232756, "total": 8381696022},
        20: {"cicilan": 37023678, "total": 9845482756},
      },
      "developer_dp": {
        1: {"cicilan": 294638604, "total": 4975363250},
        2: {"cicilan": 154667771, "total": 5151726500},
        3: {"cicilan": 108010826, "total": 5328089750},
        4: {"cicilan": 84682354, "total": 5504453000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 420912292, "total": 5050947500},
        2: {"cicilan": 220953958, "total": 5302895000},
        3: {"cicilan": 154301181, "total": 5554842500},
        4: {"cicilan": 120974792, "total": 5806790000},
      },
    },
  ),
  HouseModel(
    type: "144/228",
    model: "Foresta",
    blok: ["F4"],
    jumlahUnit: 1,
    hargaCash: 4957000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 84237769, "total": 6045666168},
        10: {"cicilan": 52383739, "total": 7277448679},
        15: {"cicilan": 42590283, "total": 8657651007},
        20: {"cicilan": 38242628, "total": 10169630761},
      },
      "developer_dp": {
        1: {"cicilan": 304339146, "total": 5139169750},
        2: {"cicilan": 159759979, "total": 5321339500},
        3: {"cicilan": 111566924, "total": 5503509250},
        4: {"cicilan": 87470396, "total": 5685679000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 434770208, "total": 5217242500},
        2: {"cicilan": 228228542, "total": 5477485000},
        3: {"cicilan": 159381319, "total": 5737727500},
        4: {"cicilan": 124957708, "total": 5997970000},
      },
    },
  ),
  HouseModel(
    type: "193/228",
    model: "Foresta",
    blok: ["E1", "E7"],
    jumlahUnit: 2,
    hargaCash: 5311000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 90253539, "total": 6477412350},
        10: {"cicilan": 56124680, "total": 7797161576},
        15: {"cicilan": 45631833, "total": 9275929897},
        20: {"cicilan": 40973693, "total": 10895886418},
      },
      "developer_dp": {
        1: {"cicilan": 326073271, "total": 5506179250},
        2: {"cicilan": 171169104, "total": 5701358500},
        3: {"cicilan": 119534382, "total": 5896537750},
        4: {"cicilan": 93717021, "total": 6091717000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 465818958, "total": 5589827500},
        2: {"cicilan": 244527292, "total": 5868655000},
        3: {"cicilan": 170763403, "total": 6147482500},
        4: {"cicilan": 133881458, "total": 6426310000},
      },
    },
  ),
  HouseModel(
    type: "193/235",
    model: "Foresta",
    blok: ["F2"],
    jumlahUnit: 1,
    hargaCash: 5422000000,
    cicilanData: {
      "kpr_syariah": {
        5: {"cicilan": 92155854, "total": 6615252489},
        10: {"cicilan": 57345471, "total": 7954206622},
        15: {"cicilan": 46681260, "total": 9457926871},
        20: {"cicilan": 41928215, "total": 11109386896},
      },
      "developer_dp": {
        1: {"cicilan": 332692813, "total": 5629022250},
        2: {"cicilan": 174545146, "total": 5836044500},
        3: {"cicilan": 121889965, "total": 6043066750},
        4: {"cicilan": 95594271, "total": 6250089000},
      },
      "developer_tanpa_dp": {
        1: {"cicilan": 475296458, "total": 5719557500},
        2: {"cicilan": 249456458, "total": 6005725000},
        3: {"cicilan": 174236319, "total": 6291892500},
        4: {"cicilan": 136676042, "total": 6578060000},
      },
    },
  ),
];
