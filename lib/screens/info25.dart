import 'package:flutter/material.dart';

class Info25Page extends StatelessWidget {
  final List filteredData;

  const Info25Page({required this.filteredData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AirCheck',
          style: TextStyle(
            fontFamily: 'Bulleto Killa',
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Particulate Matter ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text:
                      'or PM for short, is the word used to describe a mixture of solid and liquid droplets that are present in the air. It is sometimes referred to as particle pollution. Certain particles can be seen with the unaided eye due to their size or darkness, such as smoke, soot, dust, or dirt. Others are so tiny that an electron microscope is the only tool needed to identify them.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  TextSpan(
                    text: '(Particulate Matter, 2023)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                      text: '\n\nPM2.5 ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                  ),
                  TextSpan(
                    text:
                    'are tiny, inhalable particles that typically have a diameter of 2.5 micrometers or less. Long-term (months to years) exposure to PM2.5 has been associated with decreased lung function growth in children and early death, especially in those with chronic heart or lung disorders. ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Container(
                height: screenHeight * 0.9, // Adjust the multiplier as needed
                child: Image.asset(
                  'assets/index.jpg',  // Replace 'assets/index.jpg' with the actual path of your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'AQI Reference: \n'
                            'NATIONAL AMBIENT AIR QUALITY GUIDELINE VALUES\n'
                            'from: DENR-EMB-R10',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.keyboard_return_rounded,
            color: Colors.white),
        backgroundColor: Colors.red,
      ),
    );
  }
}
