import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../singup_number.dart';

class OtpScreen2 extends StatefulWidget {
  const OtpScreen2({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen2> {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          'OTP Verification',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        centerTitle: true,
        backgroundColor: TColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/banners/J (54).png",
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter the 4-digit OTP sent to your phone number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                color:dark ? TColors.white : Colors.black, ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                keyboardType: TextInputType.number,
                controller: textEditingController,
                appContext: context,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeColor: TColors.primary,
                  inactiveColor: Colors.grey,
                  selectedColor: TColors.accent,
                ),
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => SignupNumberScreen());
                    if (currentText.length == 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP Verified Successfully!')),
                      );
                      // Navigate to the next screen or process the OTP
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a 4-digit OTP')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Verify OTP',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Handle OTP resend action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('OTP Resent Successfully!')),
                  );
                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(fontSize: 16, color:  dark ? TColors.white : Colors.black,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
