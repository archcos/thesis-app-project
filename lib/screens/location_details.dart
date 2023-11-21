import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'drawer.dart';

class LocationDetails extends StatefulWidget {
  final String locationData;

  LocationDetails(this.locationData);

  @override
  _LocationDetailsState createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  List<dynamic> pmData = []; // List to store the PM data
  final Data auth = Data(); // Create an instance of the class that defines fetchPMData

  @override
  void initState() {
    super.initState();
    // Call fetchPMData when the widget is initialized
    _fetchPMData();
  }

  Future<void> _fetchPMData() async {
    try {
      final List<dynamic> data = await auth.fetchPMData(); // Call fetchPMData
      setState(() {
        pmData = data;
      });
    } catch (e) {
      print('Error fetching PM data: $e');
      // Handle the error appropriately, e.g., show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Location Data:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.locationData,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'PM Data:', // Display PM data
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Display PM data as a list of ListTiles
            Expanded(
              child: ListView.builder(
                itemCount: pmData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(pmData[index].toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
