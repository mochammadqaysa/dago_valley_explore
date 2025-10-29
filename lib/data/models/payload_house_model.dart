import 'article_model.dart';
import '../../domain/entities/paging.dart';

class PayloadHouseModel extends Paging {
  PayloadHouseModel({required this.totalResults, required this.articles})
    : super(articles: articles, totalResults: totalResults);

  final int totalResults;
  final List<ArticleModel> articles;

  @override
  factory PayloadHouseModel.fromJson(Map<String, dynamic> json) =>
      PayloadHouseModel(
        totalResults: json["totalResults"],
        articles: List.from(
          json["articles"].map((x) => ArticleModel.fromJson(x)),
        ),
      );
}
