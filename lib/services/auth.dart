import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Data with ChangeNotifier {
  static Dio _dio = Dio();
  bool _isLoggedIn = false;
  late User _user = User(name: '', email: '', avatar: '');
  late String _token = '';

  bool get authenticated => _isLoggedIn;
  User get user => _user;

  final storage = FlutterSecureStorage();

  Dio createDioInstance() {
    // Create and configure Dio instance
    Dio dio = Dio();
    // Add any necessary configurations to the Dio instance
    return dio;
  }

  Future<List<Map<String, dynamic>>> fetchPMData() async {
    try {
      String apiUrl = 'https://charcos-site1.000webhostapp.com/getdata.php';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

        // Convert relevant string values to double
        data.forEach((item) {
          item['pm25'] = double.tryParse(item['pm25'].toString()) ?? 0.0;
          item['pm10'] = double.tryParse(item['pm10'].toString()) ?? 0.0;
        });

        return data;
      } else {
        throw Exception('Failed to load PM data');
      }
    } catch (e) {
      throw Exception('Failed to fetch PM data: $e');
    }
  }


  Future<List<String>> fetchLocation() async {
    try {
      final response = await dio().get('https://charcos-site1.000webhostapp.com/location');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<String> locations =
        data.map((item) => item['Location'].toString()).toList();
        return locations;
      } else {
        throw Exception('Failed to fetch locations');
      }
    } catch (error) {
      throw Exception('Failed to fetch locations: $error');
    }
  }
}
