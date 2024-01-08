import 'package:flutter/material.dart';

class Info10Page extends StatelessWidget {
  final List filteredData;

  const Info10Page({required this.filteredData, Key? key}) : super(key: key);

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
                      text: '\n\nPM10 ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text:
                      'particles have sizes of 10 micrometers or less, making them inhalable. It also comes from industrial sources, wind-blown dust from open areas, pollen, pieces of bacteria, dust from construction sites, landfills, and farms, as well as wildfires and brush/waste burning. The surfaces of the bigger airways in the upper part of the lung are more likely to become coated in PM10. Particles that land on the lungs surface have the potential to cause inflammation and tissue damage.',
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
                  'assets/index1.jpg',  // Replace 'assets/index.jpg' with the actual path of your image
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
