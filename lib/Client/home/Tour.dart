import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

import '../authentication/LoginPage.dart';

class CarouselScreen extends StatefulWidget {
  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final List<String> imagePaths = [
    'assets/images/logo4.png',
    'assets/images/logo4.png',
    'assets/images/logo4.png',
  ];

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LoginPage(), // Login page in the background
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                top: 10, // Distance added at the top
                child: CarouselSlider(
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    autoPlayInterval: Duration(seconds: 4),
                    height: 650, // Adjusted image height
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                      if (index == imagePaths.length - 1) {
                        Future.delayed(Duration(seconds: 2), () {
                          GoRouter.of(context).go('/log');
                        });
                      }
                    },
                  ),
                  items: imagePaths.map((path) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Image.asset(
                            path,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                top: 50,
                right: 10,
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).go('/log');
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10),

                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xff0d1526),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}