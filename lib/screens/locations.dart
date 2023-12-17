// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../services/auth.dart';
// import 'drawer.dart';
// import 'location_details.dart';
//
// class Location extends StatefulWidget {
//   @override
//   _LocationState createState() => _LocationState();
// }
//
// class _LocationState extends State<Location> {
//   final storage = FlutterSecureStorage();
//   late bool isLoading = true;
//   late List<String> locationData = [];
//   late List<String> timestamps = [];
//   late Data auth = Data();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchlocation();
//   }
//
//   void _fetchlocation() async {
//     try {
//       final data = await auth.fetchLocation();
//       setState(() {
//         locationData = data;
//         timestamps = List.filled(data.length, "");
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching location data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   String getLocation(int index) {
//     return locationData[index] ?? '';
//   }
//
//   void _navigateToLocationDetails(int index) {
//     final selectedLocationData = locationData[index];
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LocationDetails(selectedLocationData),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Data'),
//         backgroundColor: Colors.green[600],
//       ),
//       body: Center(
//         child: isLoading
//             ? CircularProgressIndicator()
//             : ListView.builder(
//           itemCount: timestamps.length,
//           itemBuilder: (BuildContext context, int index) {
//             String timestamp = timestamps[index];
//
//             return Card(
//               child: GestureDetector(
//                 onTap: () {
//                   _navigateToLocationDetails(index); // Navigate to details page
//                 },
//                 child: ListTile(
//                   title: Container(
//                     color: Colors.white,
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         timestamp,
//                         textAlign: TextAlign.justify,
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${getLocation(index)}',
//                         style: TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       // Display other location-related data here
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       drawer: CustomDrawer(),
//     );
//   }
// }
//
//
