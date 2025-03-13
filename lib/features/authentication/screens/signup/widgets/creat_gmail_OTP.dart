import 'package:country_code_text_field/country_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import 'otp_page_email.dart';
import 'otp_page_number.dart';


class Otp extends StatelessWidget {
  final RxBool isEmailSelected = false.obs;

   Otp({super.key});

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
                  width: 400,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose whether to verify with an email or phone number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone, color: Colors.white),
                          const SizedBox(width: 2),
                          const Text('Phone Number', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      selected: !isEmailSelected.value,
                      onSelected: (selected) {
                        isEmailSelected.value = false;
                      },
                      selectedColor: TColors.primary,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(width: 2),
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email, color: Colors.white),
                          const SizedBox(width: 2),
                          const Text('Email', style: TextStyle(color: Colors.white)),
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
                ),
              )
              ),
              const SizedBox(height: 30),
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
