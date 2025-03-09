import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:country_code_text_field/country_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../../utils/constants/colors.dart';
import 'otp_page_email.dart';
import 'otp_page_number.dart';


class Otp extends StatelessWidget {
  final RxBool isEmailSelected = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        title: const Text(
          'Choose Email or Number',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        centerTitle: true,
        backgroundColor: TColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(
                  "assets/icons/payment_methods/choode-email-and-phone-OTP.png",
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose whether to verify with an email or phone number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.phone, color: Colors.white), // Phone icon
                        const SizedBox(width: 5), // Space between icon and text
                        const Text(
                          'Phone Number',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    selected: !isEmailSelected.value,
                    onSelected: (selected) {
                      isEmailSelected.value = false;
                    },
                    selectedColor: TColors.primary,
                    backgroundColor: Colors.grey,
                  ),

                  SizedBox(width: 20),
                  ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.email, color: Colors.white), // Email icon
                        const SizedBox(width: 5), // Space between icon and text
                        const Text(
                          'Email',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    selected: isEmailSelected.value,
                    onSelected: (selected) {
                      isEmailSelected.value = true;
                    },
                    selectedColor: TColors.primary,
                    backgroundColor: Colors.grey,
                  ),



                ],
              )),
              const SizedBox(height: 20),
              Obx(() => SizedBox(
                width: 400,
                child: isEmailSelected.value
                    ? TextField(
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Enter your Email',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: TColors.primary),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_rounded, color: TColors.primary),
                      onPressed: () => Get.to(() =>  OtpScreen()),
                    ),
                  ),
                )
                    : CountryCodeTextField(
                  keyboardType: TextInputType.number,


                  decoration: InputDecoration(

                    suffixIcon: IconButton(
                      onPressed: () => Get.to(() =>  OtpScreen2()),
                      icon: const Icon(Icons.send_rounded, color: TColors.primary),
                    ),
                    labelText: 'Phone Number'.tr,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'CM',
                ),


              )),
            ],
          ),
        ),
      ),
    );
  }
}
Future<void> sendOtpSms(String userPhone) async {
  // Create the URL with HTTPS scheme, host, and path
  final url = Uri.https('xl5x8q.api.infobip.com', '/sms/2/text/advanced');

  // Set up headers including your authorization key
  final headers = {
    'Authorization': 'App 286438dc9eff9a3bc5f4a6aa38084b9e-37111878-c4a0-4255-8879-5c1d71503f15',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Build the JSON payload with the provided phone number.
  // You can replace the "text" field with a dynamic OTP if needed.
  final body = json.encode({
    "messages": [
      {
        "destinations": [
          {"to": userPhone}
        ],
        "from": "447491163443",
        "text": "Your OTP code is: 123456" // Replace with your OTP generation logic if needed
      }
    ]
  });

  try {
    // Send the POST request
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('SMS sent successfully: ${response.body}');
    } else {
      print('Failed to send SMS. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    print('Error sending SMS: $e');
  }
}