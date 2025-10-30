import 'dart:io';

import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class HousingApi implements APIRequestRepresentable {
  HousingApi._();

  @override
  String get endpoint => APIEndpoint.housingData;

  String get path {
    return "/data";
  }

  @override
  HTTPMethod get method {
    return HTTPMethod.get;
  }

  Map<String, String> get headers => {
    "X-Api-Key": "d809d6a547734a67af23365ce5bc8c02",
  };

  Map<String, String> get query {
    return {};
  }

  @override
  get body => null;

  Future request() {
    return APIProvider.instance.request(this);
  }

  @override
  String get url => endpoint + path;
}
