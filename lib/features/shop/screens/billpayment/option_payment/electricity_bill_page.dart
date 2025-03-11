import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ElectricityBillPage extends StatelessWidget {
  const ElectricityBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of services"),
        leading: IconButton(
          icon:Icon(Icons.arrow_back, color: dark ? TColors.light : TColors.black),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
          ],
        ),
      ),
    );
  }
}
