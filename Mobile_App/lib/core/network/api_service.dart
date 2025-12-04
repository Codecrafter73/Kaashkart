

import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<Response> fetchCategories() {
    return dio.get(
      "api/user/getcategory",
      queryParameters: {"limit": 20},
      // options: Options(
      //   headers: {"Authorization": "Bearer token123"},
      // ),
    );
  }

}