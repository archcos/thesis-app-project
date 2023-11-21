import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = "https://charcos-site1.000webhostapp.com";

  dio.options.headers['accept'] = 'application/json';

  return dio;
}
