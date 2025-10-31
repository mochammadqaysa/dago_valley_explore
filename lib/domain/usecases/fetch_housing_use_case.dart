import 'package:dago_valley_explore/domain/entities/payload/housing_response.dart';
import 'package:dago_valley_explore/domain/repositories/house_repository.dart';

import '../../app/core/usecases/pram_usecase.dart';
import 'package:tuple/tuple.dart';

class FetchHousingUseCase
    extends ParamUseCase<HousingResponse, Tuple2<int, int>> {
  final HouseRepository _repo;
  FetchHousingUseCase(this._repo);

  @override
  Future<HousingResponse> execute(Tuple2<int, int> param) {
    return _repo.fetchHousingData();
  }
}
