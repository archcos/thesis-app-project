// import 'package:flutter/material.dart';
// import 'package:flutter_laravel/screens/Dashboard/dashboard.dart';
// import 'package:flutter_laravel/screens/locations.dart';
// import 'landing_screen.dart';
// import 'locations.dart';
//
// class CustomDrawer extends StatelessWidget {
//   // Define a function to create bordered ListTile widgets
//   Widget _buildBorderedListTile({
//     required String title,
//     required Icon icon,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black, // Border color
//           width: 1.0,          // Border width
//         ),
//       ),
//       child: ListTile(
//         title: Text(title),
//         leading: icon,
//         onTap: onTap,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       key: UniqueKey(),
//       child: Column(
//         children: [
//           Container(
//             height: 150, // Adjust the height as needed
//             color: Colors.green[600], // Change the background color to your preference
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/aqms.png', // Replace with your logo asset path
//                     width: 80, // Adjust the logo width
//                     height: 80, // Adjust the logo height
//                   ),
//                   Text(
//                     'Welcom to AQMS', // Replace with your app name
//                     style: TextStyle(
//                       color: Colors.black, // Change the text color
//                       fontSize: 18, // Adjust the font size
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Add the "Location" button below the custom header
//           _buildBorderedListTile(
//             title: 'Location',
//             icon: Icon(Icons.location_on), // You can change the icon accordingly
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Location()), // Replace 'Locations' with the actual class name of your location screen
//               );
//             },
//           ),
//           _buildBorderedListTile(
//             title: 'Dashboard',
//             icon: Icon(Icons.dashboard),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Dashboard()),
//               );
//             },
//           ),
//           // Add an "Exit" button at the bottom
//           Expanded(
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: _buildBorderedListTile(
//                 title: 'Exit',
//                 icon: Icon(Icons.exit_to_app), // You can change the icon accordingly
//                 onTap: () {
//                   // Handle the tap action for the "Exit" button here
//                   // This is where you can implement the logout functionality.
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => LandingPage()), // Replace 'LandPage' with the actual class name of your landing page
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
