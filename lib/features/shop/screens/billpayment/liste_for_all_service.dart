import 'package:Max_store/features/shop/screens/billpayment/service/bleu_page.dart';
import 'package:Max_store/features/shop/screens/billpayment/service/dstv_page.dart';
import 'package:Max_store/features/shop/screens/billpayment/service/mtn_page.dart';
import 'package:Max_store/features/shop/screens/billpayment/service/startime_page.dart';
import 'package:Max_store/features/shop/screens/billpayment/service/yoomee_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import 'service/orange_page.dart';
import 'service/canalplus_page.dart';


class ListeForAllService extends StatelessWidget {
  const ListeForAllService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of services"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle("Taxes"),
          _buildServiceGrid(
            context,
            services: [
              {
                'image': 'assets/images/banners/unnamed.png',
                'text': 'DOUANES',
                'onTap': () => _showBottomSheet(
                  context,
                  title: "DOUANES",
                  note: "Please enter the reference of the customs duty customer want to pay",
                  hintText: "Fill in the field",
                ),
              },
              {
                'image': 'assets/images/banners/images copie.png',
                'text': 'DGI IMPOTS',
                'onTap': () => _showBottomSheet(
                  context,
                  title: "DGI IMPOT",
                  note: "Please enter the Reference of the Tax Customer want to pay",
                  hintText: "Fill in the field",
                ),
              },
            ],
          ),
          _buildSectionTitle("Tv Subscription"),
          _buildServiceGrid(
            context,
            services: [
              {
                'image': 'assets/images/banners/new_dstv_logo.png',
                'text': 'DSTV',
                'route':  DSTVPage(),
              },
              {
                'image': 'assets/images/banners/StarTimes_B2C-02_(2).png',
                'text': 'StarTimes',
                'route':  StartimesPage(),
              },
              {
                'image': 'assets/images/banners/Canal_logo.png',
                'text': 'CanalPlus',
                'route':  CanalplusPage(),
              },
            ],
          ),
          _buildSectionTitle("Utility bills"),
          _buildServiceGrid(
            context,
            services: [
              {
                'image': 'assets/images/banners/Eneo-Cameroon-Logo-Vector.svg-.png',
                'text': 'ENEO Bills/Postpaid',
                'onTap': () => _showUtilityBottomSheet(
                  context,
                  title: "ENEO",
                  note: "Please enter the Contract No or Bill No found on your ENEO Bill",
                ),
              },
              {
                'image': 'assets/images/banners/1524002210.jpg',
                'text': 'Camwater Bills',
                'onTap': () => _showUtilityBottomSheet(
                  context,
                  title: "CAMWATER",
                  note: "Please enter the Contract No or Bill No found on your Camwater Bill",
                ),
              },
            ],
          ),
          _buildSectionTitle("Airtime"),
          _buildServiceGrid(
            context,
            services: [
              {
                'image': 'assets/images/banners/Orange_logo.jpg',
                'text': 'ORANGE Recharge/Airtime',
                'route':  OrangePage(),
              },
              {
                'image': 'assets/images/banners/MTN_logo copie.jpg',
                'text': 'MTN Recharge/Topup',
                'route':  MtnPage(),
              },
              {
                'image': 'assets/images/banners/YOOME_logo copie.jpg',
                'text': 'YOOMEE Recharge/Topup',
                'route': YoomeePage(),
              },
              {
                'image': 'assets/images/banners/BLEU_logo copie.jpg',
                'text': 'CAMTEL Recharge/Topup',
                'route': BleuPage(),
              },
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Helper method to build a grid of services
  Widget _buildServiceGrid(BuildContext context, {required List<Map<String, dynamic>> services}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return GestureDetector(
          onTap: service['onTap'] ?? () => Get.to(service['route']),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    service['image'],
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 5),
                Flexible(
                  child: Text(
                    service['text'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Reusable bottom sheet for mobile services
  void _showMobileServiceBottomSheet(BuildContext context, {required String title, required String note}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Service",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text("Mobile Number"),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Help Message"),
                                  content: Text("Please enter your $title mobile number"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.info,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Fill in the field",
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        keyboardType: TextInputType.phone,
                        obscureText: false,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {
                          print("User typed: $value");
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "NOTE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note,
                            style: const TextStyle(fontSize: 12, color: TColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Reusable bottom sheet for taxes and DGI
  void _showBottomSheet(BuildContext context, {required String title, required String note, required String hintText}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Bill",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text("Reference No"),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Help Message"),
                                  content: const Text("Fill in the field"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.info,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: hintText,
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {
                          print("User typed: $value");
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "NOTE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note,
                            style: const TextStyle(fontSize: 12, color: TColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Reusable bottom sheet for utility bills
  void _showUtilityBottomSheet(BuildContext context, {required String title, required String note}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Bill",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text("Contract Number"),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Help Message"),
                                  content: Text("Please enter the Contract No or Bill No found on your $title Bill"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.info,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Fill in the field",
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {
                          print("User typed: $value");
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "NOTE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note,
                            style: const TextStyle(fontSize: 12, color: TColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}