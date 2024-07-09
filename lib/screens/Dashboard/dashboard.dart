import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/auth.dart';
import '../circular.dart';
import '../colors.dart';
import '../info25.dart';
import 'history_container.dart';
import 'location.dart';
import 'meter.dart';
import 'package:intl/intl.dart';

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
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _pageController = PageController(initialPage: _selectedIndex);
    _fetchPMData();

    // Schedule the timer to fetch data every minute
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      if (_isMounted) {
        _fetchPMData();
      }
    });

    // Add listener for page changes
    _pageController.addListener(() {
      _onPageChanged(_pageController.page?.round() ?? 0);
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    _pageController.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchPMData() async {
    try {
      final data = await auth.fetchPMData();

      if (_isMounted) {
        setState(() {
          pmData = List<Map<String, dynamic>>.from(data);
          timestamps = pmData.map((item) => item['timestamp'] as String).toList();
          isLoading = false;

          // Sort data by id in descending order
          pmData.sort((a, b) {
            final idA = int.tryParse(a['id'].toString()) ?? 0;
            final idB = int.tryParse(b['id'].toString()) ?? 0;
            return idB.compareTo(idA);
          });


          // Set latest data
          if (pmData.isNotEmpty) {
            latestData = pmData.last;
          }
        });
      }
    } catch (e) {
      if (_isMounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error fetching PM data: $e');
    }
  }

  String formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formattedDate = DateFormat('h a MMMM d, y', 'en_US').format(dateTime);
    return formattedDate;
  }


  String _getImagePath(String pm25remarks) {
    switch (pm25remarks) {
      case 'Good':
        return 'assets/icons/good.png';
      case 'Fair':
        return 'assets/icons/fair.png';
      case 'Unhealthy':
        return 'assets/icons/unhealthy.png';
      case 'Very Unhealthy':
        return 'assets/icons/vunhealthy.png';
      case 'Severely Unhealthy':
        return 'assets/icons/sunhealthy.png';
      case 'Emergency':
        return 'assets/icons/emergency.png';
      default:
        return 'assets/icons/good.png'; // Provide a default image if none of the above conditions match
    }
  }


  void _onItemTapped(int index) {
    if (_isMounted && _selectedIndex != index) {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    if (_isMounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
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
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Info25Page(filteredData: [latestData]),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.0),
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.question_mark_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPMData, // call the _fetchPMData method when refreshing
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
                Container(
                  color: getColorForRemarks(latestData['pm25remarks'] ?? ''),
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
                            String location =
                            item['location'] as String;

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
                                          child: RadialGaugeWidget(
                                            pmValue: latestData['pm25'],
                                            pmRemarks: latestData['pm25remarks'],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      margin: EdgeInsets.only(top: 16.0),
                                      padding: EdgeInsets.all(3.0), // Outer padding to create space for the double border
                                      decoration: BoxDecoration(
                                        color: Colors.transparent, // Outer container transparent to show inner container
                                        borderRadius: BorderRadius.circular(12.0), // Outer border radius slightly larger
                                        border: Border.all(
                                          color: Colors.white, // Outer border color
                                          width: 2.0, // Outer border width
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(4.0), // Inner padding for content
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(10.0), // Inner border radius
                                          border: Border.all(
                                            color: Colors.white, // Inner border color
                                            width: 2.0, // Inner border width
                                          ),
                                        ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center, // Centers all columns within the row
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center, // Centers content within the column
                                                  children: [
                                                    Center(
                                                      child: Image.asset(
                                                        _getImagePath(latestData['pm25remarks']),
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Center(
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min, // Ensures the row takes minimal space
                                                        children: [
                                                          Icon(
                                                            Icons.location_on, // The location icon
                                                            color: Colors.red, // Adjust the color of the icon if needed
                                                          ),
                                                          Text(
                                                            location.contains(' ') ? '${location.split(' ')[0]}\n${location.split(' ').sublist(1).join(' ')}' : location,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start, // Centers content within the column
                                                  children: [
                                                    Text(
                                                      'PM2.5: ${latestData['pm25']}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        fontStyle: FontStyle.italic,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors.grey,
                                                            blurRadius: 2,
                                                            offset: Offset(1, 1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'PM10: ${latestData['pm10']}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        fontStyle: FontStyle.italic,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors.grey,
                                                            blurRadius: 2,
                                                            offset: Offset(1, 1),
                                                          ),
                                                        ],
                                                      ),// Adjust text color
                                                    ),
                                                  ],
                                                ),
                                              ), Expanded(
                                                child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center, // Centers content within the column
                                                  children: [
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        style: TextStyle(color: Colors.black),
                                                        children: [
                                                          TextSpan(
                                                            text: 'Air Quality Index \n',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          TextSpan(
                                                            text: '${latestData['pm25remarks']}',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: getColorForRemarks(latestData['pm25remarks'] ?? ''),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Info25Page(filteredData: [latestData])),
                                                          );
                                                        },
                                                        child: const Text('See More >'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ),
                                            ],
                                          )

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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Locations',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: getColorForRemarks(latestData['pm25remarks'] ?? ''),
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
    );
  }
}
