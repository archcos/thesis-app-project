import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Dashboard/dashboard.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo1.png',
                      width: 200,
                    ),
                    Text(
                      'AirCheck',
                      style: TextStyle(
                        fontFamily: 'Bulleto Killa',
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.16,
                        letterSpacing: 0,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.16,
                        letterSpacing: 0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Air Quality Monitoring System\nfor\nCagayan de Oro City',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.2,
                          letterSpacing: 0,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Request notification permissions with the current context
                        _requestNotificationPermissions(context);

                        // Navigate to the Dashboard class
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ),
                        );
                      },
                      child: Text('CHECK AIR QUALITY'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF75FA61),
                        foregroundColor: Colors.green[900],
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                    ),
                    SizedBox(height: 90),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Developed By\n'),
                            TextSpan(
                              text: 'BreAzy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to request notification permissions
  void _requestNotificationPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      // Notification permissions granted
    } else {
      // Handle the case where the user denies permission
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notification Permission Denied'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You have denied notification permissions. You can change this in the app settings anytime to receive notifications and warnings.',
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the current dialog
                        _openAppSettings(); // Open app settings
                      },
                      child: Text('Open App Settings'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the current dialog
                        // Handle "Maybe Later" action here
                      },
                      child: Text('Maybe Later'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Function to open app settings
  void _openAppSettings() {
    openAppSettings();
  }
}
