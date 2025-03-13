import 'package:Max_store/features/shop/screens/ticket_office/option_page/photography_detail.dart';
import 'package:Max_store/features/shop/screens/ticket_office/option_page/photography_detail2.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart'; // Make sure you import Getx if using Obx
import '../../../../../utils/constants/colors.dart';

class Photos extends StatelessWidget {
  const Photos({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> carouselImages = [
      'assets/images/banners/photo1.jpg',
      'assets/images/banners/photo2.jpg',
      'assets/images/banners/photo3.jpg',
      'assets/images/banners/photo4.jpg',
      'assets/images/banners/photo5.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pop(context);  // Navigates back to the previous screen
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
                  "Shooting Photo",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Netflix-Style Carousel Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 250.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: 0.45,
                  aspectRatio: 2 / 8,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                ),
                items: carouselImages.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Image.asset(image, fit: BoxFit.cover, width: 500),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              Text("Partner", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Center(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () => Get.to(() => PhotographyPage()),
                      borderRadius: BorderRadius.circular(12), // Ensures the ripple effect matches the card shape
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.asset('assets/images/banners/banner photo.jpg',
                                    fit: BoxFit.cover, height: 200, width: 400),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.favorite_border, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Max Art Photography",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("Shooting Photo", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(height: 10),
              Center(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () => Get.to(() => PhotographyPage2()),
                      borderRadius: BorderRadius.circular(12), // Ensures the ripple effect matches the card shape
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.asset('assets/images/banners/Banner_YAOUNDE.jpg',
                                    fit: BoxFit.cover, height: 200, width: 400),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.favorite_border, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Max Art Photography",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("Shooting Photo", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
