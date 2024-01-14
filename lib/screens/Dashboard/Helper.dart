import 'package:flutter/material.dart';

class Helper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.black, // You can adjust the color as needed
              onPressed: () {
                Navigator.of(context).pop(); // Add exit functionality
              },
            ),
          ),
        ],
      ),
      body: Stack(
          children: [
            Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,),
            ImageSlideshow(
              images: [
                AssetImage('assets/help/help1.png'),
                AssetImage('assets/help/help2.png'),
                AssetImage('assets/help/help3.png'),
              ],
            ),
          ]
      ),
    );
  }
}


class ImageSlideshow extends StatefulWidget {
  final List<ImageProvider> images;

  ImageSlideshow({required this.images});

  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image(
                image: widget.images[index],
                fit: BoxFit.fill,
              );
            },
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
                (index) => buildDot(index, _currentPage == index),
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index, bool isActive) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
