import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/success_screen/success_payment.dart';
import '../../../../../home_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../payment_detail/payment_liste.dart';

class PhotographyPage extends StatefulWidget {
  const PhotographyPage({super.key});

  @override
  _PhotographyPageState createState() => _PhotographyPageState();
}

class _PhotographyPageState extends State<PhotographyPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredSubscriptions = [];

  final List<Map<String, String>> subscriptions = [
    {
      "title": "Pregnancy session - Pack 1",
      "price": "15000 XAF",
      "description": "Pack containing 5 HD photos, decorations included, free make-up, 1 free traditional garment"
    },
    {
      "title": "Pregnancy session - Pack 2",
      "price": "30000 XAF",
      "description": "Pack containing 5 HD photos, decorations included, make-up offered, 2 traditional clothes offered (royal and traditional dress) 1 photo enlargement"
    },
    {
      "title": "Children's Birthday Session",
      "price": "15000 XAF",
      "description": "Pass giving access to 5 HD photos including decorations"
    },
    {
      "title": "Individual Shooting Session",
      "price": "20000 XAF",
      "description": "Make up and accessories included."
    },
    {
      "title": "Traditional Shooting Session",
      "price": "30000 XAF",
      "description": "Make up and accessories included."
    },
    {
      "title": "Portrait Shooting Session",
      "price": "35000 XAF",
      "description": "Free make-up"
    },
    {
      "title": "Baby shooting session",
      "price": "10000 XAF",
      "description": ""
    },

  ];
  final String userId = 'Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2';
  final TextEditingController addadditionalinstructionsController = TextEditingController();

  @override
  Future<double> getUserBalance() async {
    var userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (!userDoc.exists) return 0.0;
    return (userDoc['balance'] as num).toDouble();
  }

  void processPayment(BuildContext context, Map<String, String> item) async {


    double balance = await getUserBalance();
    double? price = double.tryParse(item['price']!.split(' ')[0]);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid price format.")));
      return;
    }

    if (balance < price) {
      TLoaders.warningSnackBar(
        title: 'Insufficient Balance'.tr,
        message: 'You do not have enough balance to complete this purchase.'.tr,
      );
      return;
    }

    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'balance': balance - price,
    });

    await FirebaseFirestore.instance.collection('Users').doc(userId).collection('Services').add({
      'userId': userId,
      'amount': '$price FCFA',
      'paymentMethod': 'Wallet Max Store',
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Successful',
      'description': '${item['description']}',
      'title': '${item['title']}',
      'add additional instructions':addadditionalinstructionsController.text,
    });


    //TLoaders.successSnackBar(
     // title: 'Payment Successful'.tr,
     // message: 'Your payment has been processed successfully.'.tr,
   // );
  }
  @override
  void initState() {
    super.initState();
    filteredSubscriptions = subscriptions;
    _searchController.addListener(_filterSubscriptions);
  }

  void _filterSubscriptions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredSubscriptions = subscriptions.where((item) {
        final title = item['title']!.toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        title: const Text(
          "Shooting Photo",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: TColors.primary, // Replace with your primary color
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image with rounded top corners
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              child: Image.asset(
                'assets/images/banners/banner photo.jpg', // Replace with your image path
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),

            // Rating & Minimum Order Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.star1, color: Color(0xFFF9A825)),
                    const SizedBox(width: 5),
                    const Text("70,5 (100 avis)"),
                  ],
                ),
                //const Text(
                 // "1000 F Achat minimum",
                  //style: TextStyle(fontWeight: FontWeight.bold),
                //),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search in Shooting Photo",
                prefixIcon: Icon(Iconsax.search_normal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Promo Code Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("No promo code"),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Iconsax.add),
                    label: const Text("Add a promo code"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tickets Section
            const Text(
              "Tickets",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // List of subscriptions
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredSubscriptions.length,
              itemBuilder: (context, index) {
                final item = filteredSubscriptions[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/banners/Prom-Tickets.webp', // Replace with your image path
                      width: 50,
                      height: 50,
                    ),
                  ),
                  title: Text(
                    item['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),
                  ),
                  subtitle:  Text(
                    item['description']!,
                    maxLines: 2, // Adjust as needed
                    overflow: TextOverflow.ellipsis,
                  ),

                  trailing: Text(
                    item['price']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      builder: (builder) {
                        return FractionallySizedBox(
                          heightFactor: 0.80,
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
                                        const SizedBox(width: 5),

                                        Text(
                                          item['title']!,
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
                                        const Text("Selected plan"),
                                        const SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Help Message"),
                                                  content: const Text("Subscribed Package"),
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
                                    Center(
                                      child: Container(
                                        width: 420,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.asset(
                                                'assets/images/banners/Prom-Tickets.webp', // Replace with your image path
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    item['title']!,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(item['description']!),
                                                  Text(item['price']!,style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 40),
                                    Row(
                                      children: [
                                        const Text("Add additional instructions"),
                                        const SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Help Message"),
                                                  content: const Text("Add additional instructions"),
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

                                    // Input Field
                                    Container(
                                      width: 400,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: SizedBox(
                                        width: 400, // Adjust width as needed
                                        height: 100, // Adjust height as needed
                                        child: TextFormField(
                                          controller: addadditionalinstructionsController,
                                          decoration: InputDecoration(
                                            hintText: "Add additional instructions",
                                            border: OutlineInputBorder(),
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
                                      )
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                        width: 220,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Your balance:',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                        StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance.collection('Users').doc('Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2').snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator(color: Colors.white);
                                            }
                                            if (!snapshot.hasData || !snapshot.data!.exists) {
                                              return Text(
                                                "0 F CFA",
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: TColors.primary),
                                              );
                                            }

                                            var data = snapshot.data!;
                                            double balance = (data['balance'] is String)
                                                ? double.tryParse(data['balance']) ?? 0.0
                                                : (data['balance'] as num).toDouble();

                                            return Text(
                                              "${balance.toStringAsFixed(0)} F CFA",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: TColors.primary),
                                            );
                                          },
                                        ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Note Section
                                   // Row(
                                     // children: [
                                       // const Text(
                                        //  "NOTE:",
                                        //  style: TextStyle(
                                         //   fontSize: 10,
                                         //   fontWeight: FontWeight.w700,
                                         //   color: Colors.blue, // Replace with your primary color
                                         // ),
                                        //),
                                       // const SizedBox(width: 8),
                                       // const Expanded(
                                        //  child: Text(
                                         //   "Please enter the 14-digit code of your decoder",
                                         //   style: TextStyle(fontSize: 10, color: Colors.blue), // Replace with your primary color
                                        //  ),
                                      //  ),
                                     // ],
                                    //),
                                    const SizedBox(height: 40),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // Show the loading indicator
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false, // Prevent closing by tapping outside
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            },
                                          );

                                          // Simulate a payment process that takes 3 seconds
                                          await Future.delayed(Duration(seconds: 3));

                                          // Perform payment processing
                                           processPayment(context, item);

                                          // Close the loading dialog
                                          Navigator.of(context, rootNavigator: true).pop();

                                          // Show the success screen
                                          Get.offAll(() => SuccessPayment(
                                            image: TImages.paymentSuccessfulAnimation,
                                            title: 'Payment Success!'.tr,
                                            subTitle: 'Your payment has been successfully made, thank you for your trust.'.tr,
                                            onPressed: () => Get.offAll(() => const HomeMenu()),
                                            onPressed2: () => Get.offAll(() => HistoryPage(userId: 'Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2')),
                                          ));
                                        },
                                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                                        child: Text("Confirm Payment"),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}