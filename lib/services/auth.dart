import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Data with ChangeNotifier {
  Future<List<Map<String, dynamic>>> fetchPMData() async {
    try {
      String apiUrl = 'https://airqms-cdo.000webhostapp.com/getdata.php';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedJson = jsonDecode(response.body);

        if (decodedJson != null && decodedJson is List) {
          List<Map<String, dynamic>> data = decodedJson.cast<Map<String, dynamic>>();

          // Convert relevant string values to double
          data.forEach((item) {
            item['pm25'] = double.tryParse(item['pm25']?.toString() ?? '0.0') ?? 0.0;
            item['pm10'] = double.tryParse(item['pm10']?.toString() ?? '0.0') ?? 0.0;
          });

          print(data);

          return data;
        } else {
          throw Exception('Invalid JSON format or null response');
        }
      } else {
        throw Exception('Failed to load PM data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch PM data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAverage() async {
    try {
      String apiUrl = 'https://airqms-cdo.000webhostapp.com/getaverage.php';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedJson = jsonDecode(response.body);

        if (decodedJson != null && decodedJson is List) {
          List<Map<String, dynamic>> data = decodedJson.cast<Map<String, dynamic>>();

          // Convert relevant string values to double
          data.forEach((item) {
            item['pm25_average'] = double.tryParse(item['pm25_average']?.toString() ?? '0.0') ?? 0.0;
            item['pm10_average'] = double.tryParse(item['pm10_average']?.toString() ?? '0.0') ?? 0.0;
          });

          print(data);

          return data;
        } else {
          throw Exception('Invalid JSON format or null response');
        }
      } else {
        throw Exception('Failed to load PM data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch PM data: $e');
    }
  }

  Future<List<String>> fetchLocation() async {
    try {
      String apiUrl = 'https://charcos-site1.000webhostapp.com/location';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
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


