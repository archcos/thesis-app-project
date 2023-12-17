import 'package:flutter/material.dart';
import 'package:flutter_laravel/screens/Dashboard/location.dart';
import 'package:flutter_laravel/screens/Dashboard/pm10meter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../services/auth.dart';
import '../circular.dart';
import '../details.dart';
import '../drawer.dart';
import 'package:intl/intl.dart';

import 'dashboard.dart';
import 'history_container.dart';
import 'meter.dart';

class PM10Tab extends StatefulWidget {
  @override
  _PM10TabState createState() => _PM10TabState();
}

class _PM10TabState extends State<PM10Tab> {
  final storage = FlutterSecureStorage();
  late bool isLoading = true;

  late List<Map<String, dynamic>> pmData = [];
  late List<String> timestamps = [];
  late String selectedLocation = '';
  late Data auth = Data();
  late Map<String, dynamic> latestData = {};

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index.
    switch (index) {
      case 0:
      // Redirect to the Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
        break;
      case 1:
      // Handle Location tab
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LocationTab()),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPMData();
  }

  void _fetchPMData() async {
    try {
      final data = await auth.fetchPMData();
      setState(() {
        pmData = List<Map<String, dynamic>>.from(data);
        timestamps = pmData.map((item) => item['timestamp'] as String).toList();
        isLoading = false;

        // Sort data by timestamp in descending order
        pmData.sort((a, b) {
          final timestampA = DateTime.parse(a['timestamp']);
          final timestampB = DateTime.parse(b['timestamp']);
          return timestampB.compareTo(timestampA);
        });

        // Set latest data
        if (pmData.isNotEmpty) {
          latestData = pmData.first;
        }
      });
    } catch (e) {
      print('Error fetching PM data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formattedDate =
    DateFormat('h a MMMM d, y', 'en_US').format(dateTime);
    return formattedDate;
  }

  String getLocation(int index) {
    return pmData[index]['location'] ?? '';
  }

  double getPM25(int index) {
    return (pmData[index]['pm25'] ?? 0).toDouble();
  }

  String getpm25Remarks(int index) {
    return pmData[index]['pm25remarks'] ?? '';
  }

  double getPM10(int index) {
    return (pmData[index]['pm10'] ?? 0).toDouble();
  }

  String getpm10Remarks(int index) {
    return pmData[index]['pm10remarks'] ?? '';
  }

  List<Map<String, dynamic>> filterDataByLocation(
      List<Map<String, dynamic>> data, String location) {
    if (location.isEmpty) {
      return data;
    }
    return data.where((item) => item['location'] == location).toList();
  }

  List<Map<String, dynamic>> filterDataByCurrentDate(
      List<Map<String, dynamic>> data) {
    final now = DateTime.now();
    final formattedCurrentDate = DateFormat('yyyy-MM-dd').format(now);

    return data.where((item) {
      final itemDate = DateTime.parse(item['timestamp'] as String);
      final formattedItemDate = DateFormat('yyyy-MM-dd').format(itemDate);
      return formattedItemDate == formattedCurrentDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that latestData is not null before using its properties
    final List<Map<String, dynamic>> filteredData = [if (latestData != null) latestData];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'AQMS',
          style: TextStyle(
            fontFamily: 'Bulleto Killa', // Replace 'YourCursiveFont' with the actual cursive font you want to use
            fontStyle: FontStyle.italic, // This sets the italic style
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: CircularProgressWithDuration(duration: Duration(seconds: 5)),
          ),
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.transparent,
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Center(
                child: ListView.builder(
                  itemCount: filteredData.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == filteredData.length) {
                      // Display additional card for all PM2.5 data
                      return Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: HistoryContainer(pmData: pmData),
                      );
                    } else {
                      // Display existing cards
                      final item = filteredData[index];
                      String timestamp = item['timestamp'] as String;
                      String formattedTimestamp =
                      formatTimestamp(timestamp);
                      String location = item['location'] as String;

                      return Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: ListTile(
                          title: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Current Air Quality',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      formattedTimestamp,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RadialGaugeWidget1(
                                      pmValue:
                                      getPM10(filteredData.indexOf(item)),
                                      pmRemarks:
                                      getpm10Remarks(filteredData.indexOf(item)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Text(
                                  '$location',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigate to the DetailsPage class when the "Details" button is tapped.
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DetailsPage(filteredData: [latestData])),
                                      );
                                    },
                                    child: const Text('Show Details'),
                                  )
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.air_rounded),
            label: 'PM2.5',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud,
              color: Colors.white,),
            label: 'PM10',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[900],
        onTap: _onItemTapped,
        backgroundColor: Colors.green[600],
      ),
    );
  }
}
