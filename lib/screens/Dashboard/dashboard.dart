import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/screens/Dashboard/location.dart';
import 'package:flutter_laravel/screens/info25.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/auth.dart';
import '../circular.dart';
import 'package:intl/intl.dart';

import 'history_container.dart';
import 'meter.dart';
import 'pm10tab.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final storage = FlutterSecureStorage();
  late bool isLoading = true;
  late PageController _pageController;
  late List<Map<String, dynamic>> pmData = [];
  late List<String> timestamps = [];
  late String selectedLocation = '';
  late Data auth = Data();
  late Map<String, dynamic> latestData = {};

  int _selectedIndex = 0;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _fetchPMData();
    // Schedule the timer to fetch data every minute
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      _fetchPMData();
    });

    // Add listener for page changes
    _pageController.addListener(() {
      _onPageChanged(_pageController.page?.round() ?? 0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchPMData() async {
    try {
      final data = await auth.fetchPMData();
      setState(() {
        pmData = List<Map<String, dynamic>>.from(data);
        timestamps = pmData.map((item) => item['timestamp'] as String).toList();
        isLoading = false;

        // Sort data by id in descending order
        pmData.sort((a, b) {
          final idA = int.parse(a['id'].toString());
          final idB = int.parse(b['id'].toString());
          return idB.compareTo(idA);
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

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that latestData is not null before using its properties
    final List<Map<String, dynamic>> filteredData = [latestData];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'AirCheck',
          style: TextStyle(
            fontFamily: 'Bulleto Killa',
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchPMData();
        },
        child: PageView(
          controller: _pageController,
          children: [
            // Home Tab
            Stack(
              children: [
                Center(
                  child: CircularProgressWithDuration(
                      duration: Duration(seconds: 5)),
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
                            final item = filteredData[index];
                            String timestamp =
                            item['timestamp'] as String;
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
                                            'Current Air Quality - PM2.5',
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
                                          child: RadialGaugeWidget(
                                            pmValue: getPM25(
                                                filteredData.indexOf(item)),
                                            pmRemarks: getpm25Remarks(
                                                filteredData.indexOf(item)),
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Info25Page(
                                                        filteredData: [
                                                          latestData
                                                        ])),
                                          );
                                        },
                                        child: const Text(
                                            'See More Information'),
                                      ),
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
            // Location Tab
            LocationTab(),
            // PM10 Tab
            PM10Tab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.air),
            label: 'PM2.5',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Locations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'PM10',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.green[600],
      ),
    );
  }
}
