import 'package:dago_valley_explore/data/providers/network/apis/housing_api.dart';

import '../models/paging_model.dart';

class HouseRepositoryImpl extends ArticleRepository {
  @override
  Future<PagingModel> fetchHeadline(int page, int pageSize) async {
    final response = await HousingApi.fetchHeadline(page, pageSize).request();
    return PagingModel.fromJson(response);
  }

  @override
  Future<PagingModel> fetchNewsByCategory(
    String keyword,
    int page,
    int pageSize,
  ) async {
    final response = await ArticleAPI.fetchNews(
      keyword,
      page,
      pageSize,
    ).request();
    return PagingModel.fromJson(response);
  }
}
