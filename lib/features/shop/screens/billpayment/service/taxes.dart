import 'package:Max_store/features/shop/screens/billpayment/service/startime_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../utils/constants/colors.dart';
import 'canalplus_page.dart';
import 'dstv_page.dart';



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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Taxes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Wrap GridView.builder inside Expanded
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1,
                ),
                itemCount: 2, // Number of services
                itemBuilder: (context, index) {
                  List<Map<String, String>> services = [
                    {
                      'image': 'assets/images/banners/unnamed.png',
                      'text': 'DOUANES',
                    },
                    {
                      'image': 'assets/images/banners/images copie.png',
                      'text': 'DGI IMPOTS',
                    },
                  ];

                  var service = services[index];

                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        _showDouaneBottomSheet(context);
                      } else {
                        _showDgiImpotBottomSheet(context);
                      }
                    },
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
                              service['image']!,
                              width: 100,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              service['text']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Text(
              "Tv Subscription",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Wrap GridView.builder inside Expanded
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust number of columns as needed
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.9, // Adjust aspect ratio
                ),
                itemCount: 3, // Set item count to 3
                itemBuilder: (context, index) {
                  // List of services with their corresponding navigation routes
                  List<Map<String, dynamic>> services = [
                    {
                      'image': 'assets/images/banners/new_dstv_logo.png',
                      'text': 'DSTV',
                      'route': DSTVPage(), // Navigate to DSTV page
                    },
                    {
                      'image': 'assets/images/banners/StarTimes_B2C-02_(2).png',
                      'text': 'StarTimes',
                      'route': StartimesPage(), // Navigate to StarTimes page
                    },
                    {
                      'image': 'assets/images/banners/Canal_logo.png',
                      'text': 'CanalPlus',
                      'route': CanalplusPage(), // Navigate to CanalPlus page
                    },
                  ];

                  var service = services[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(service['route']); // Navigate using Get.to()
                    },
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
                              service['image']!,
                              width: 110,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              service['text']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Text(
              "Utility bills",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1,
                ),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
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
                                          const Text(
                                            "ENEO",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: TColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Text("Contract Number"),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () {
                                              // Show the dialog when the icon is tapped
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Help Message"),
                                                    content: Text("Please enter the Contract No or Bill No found on your ENEO Bill"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Close the dialog
                                                        },
                                                        child: Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(
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
                                            color: Colors.grey[200], // Background color
                                            borderRadius: BorderRadius.circular(8), // Rounded corners
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Fill in the field",
                                              border: OutlineInputBorder(),
                                              filled: true, // Enables background color
                                              fillColor: Colors.grey[300], // Light grey background
                                            ),
                                            keyboardType: TextInputType.text,
                                            obscureText: false,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 16, color: Colors.black),
                                            onChanged: (value) {
                                              print("User typed: $value");
                                            },
                                          )
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
                                            child: const Text(
                                              "Please enter the Contract No or Bill No found on your ENEO Bill",
                                              style: TextStyle(fontSize: 12, color: TColors.primary),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 50),
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
                    },
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
                              "assets/images/banners/Eneo-Cameroon-Logo-Vector.svg-.png",
                              width: 100,
                              height: 100,
                            ),
                          ),

                          Flexible(
                            child: Text(
                              "ENEO Bills/Postpaid",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1,
                ),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
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
                                          const Text(
                                            "CAMWATER",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: TColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Text("Contract Number"),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () {
                                              // Show the dialog when the icon is tapped
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Help Message"),
                                                    content: Text("Please enter the Contract No or Bill No found on your Camwater Bill"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Close the dialog
                                                        },
                                                        child: Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(
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
                                            color: Colors.grey[200], // Background color
                                            borderRadius: BorderRadius.circular(8), // Rounded corners
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Fill in the field",
                                              border: OutlineInputBorder(),
                                              filled: true, // Enables background color
                                              fillColor: Colors.grey[300], // Light grey background
                                            ),
                                            keyboardType: TextInputType.text,
                                            obscureText: false,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 16, color: Colors.black),
                                            onChanged: (value) {
                                              print("User typed: $value");
                                            },
                                          )
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
                                            child: const Text(
                                              "Please enter the Contract No or Bill No found on your Camwater Bill",
                                              style: TextStyle(fontSize: 12, color: TColors.primary),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 50),
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
                    },
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
                              "assets/images/banners/1524002210.jpg",
                              width: 100,
                              height: 100,
                            ),
                          ),

                          Flexible(
                            child: Text(
                              "Camwater Bills",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages for each service
void _showDouaneBottomSheet(BuildContext context) {
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
                    const Text(
                      "DOUANES",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    const Text("Customs Duty Reference"),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Show the dialog when the icon is tapped
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Help Message"),
                              content: Text("Fill in the field"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
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
                      color: Colors.grey[200], // Background color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Fill in the field",
                        border: OutlineInputBorder(),
                        filled: true, // Enables background color
                        fillColor: Colors.grey[300], // Light grey background
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      onChanged: (value) {
                        print("User typed: $value");
                      },
                    )
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Text(
                      "NOTE:",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: TColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: const Text(
                        "Please enter the reference of the customs duty customer want to pay",
                        style: TextStyle(fontSize: 10, color: TColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
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
      );
    },
  );
}

// Show Bottom Sheet for DGI IMPOTS
void _showDgiImpotBottomSheet(BuildContext context) {
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
                      const Text(
                        "DGI IMPOT",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const Text("Reference No"),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          // Show the dialog when the icon is tapped
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Help Message"),
                                content: Text("Fill in the field"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(
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
                        color: Colors.grey[200], // Background color
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Fill in the field",
                          border: OutlineInputBorder(),
                          filled: true, // Enables background color
                          fillColor: Colors.grey[300], // Light grey background
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {
                          print("User typed: $value");
                        },
                      )
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text(
                        "NOTE:",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: TColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: const Text(
                          "Please enter the Reference of the Tax Customer want to pay",
                          style: TextStyle(fontSize: 10, color: TColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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




