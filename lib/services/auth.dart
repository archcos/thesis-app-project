import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Data with ChangeNotifier {
  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Data() {
    _initializeLocalNotifications();
    _startTimer();
  }

  Future<void> fetchData() async {
    try {
      List<Map<String, dynamic>> data = await fetchPMData();
      notifyListeners();
      _checkNotificationCriteria(data);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> startFetchingDataAndNotify() async {
    try {
      await fetchData(); // Fetch data immediately
    } catch (e) {
      print('Error fetching data and notifying: $e');
    }
  }

  void _checkNotificationCriteria(List<Map<String, dynamic>> data) {
    double pm25Threshold = 35.1;
    double pm10Threshold = 154.1;

    bool sendNotification = false;

    if (data.isNotEmpty) {
      Map<String, dynamic> latestData = data.last;
      if (latestData['pm25'] > pm25Threshold ||
          latestData['pm10'] > pm10Threshold) {
        sendNotification = true;
      }
    }

    if (sendNotification) {
      _sendNotification();
    }
  }
  Future<void> _sendNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'air_quality_channel',
      'Air Quality Alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notif'),
      styleInformation: DefaultStyleInformation(true, true),
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Air Quality Alert',
      'Air Quality is not Healthy! Check AQI Level',
      platformChannelSpecifics,
    );
  }

  void _startTimer() {
    fetchData(); // Fetch data immediately

    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      fetchData(); // Fetch data every 5 minutes
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeLocalNotifications() {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<List<Map<String, dynamic>>> fetchPMData() async {
    try {
      String apiUrl = 'https://airqms-cdo.000webhostapp.com/getdata.php';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedJson = jsonDecode(response.body);

        if (decodedJson != null && decodedJson is List) {
          List<Map<String, dynamic>> data = decodedJson.cast<Map<String, dynamic>>();

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
          List<Map<String, dynamic>> average =
          decodedJson.cast<Map<String, dynamic>>();

          // Convert relevant string values to double
          average.forEach((item) {
            item['pm25_average'] =
                double.tryParse(item['pm25_average']?.toString() ?? '0.0') ??
                    0.0;
            item['pm10_average'] =
                double.tryParse(item['pm10_average']?.toString() ?? '0.0') ??
                    0.0;
          });

          print(average);

          return average;
        } else {
          throw Exception('Invalid JSON format or null response');
        }
      } else {
        throw Exception(
            'Failed to load PM data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch PM data: $e');
    }
  }
}
