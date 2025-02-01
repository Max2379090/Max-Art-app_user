import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../styles/spacing_styles.dart';

class SuccessPayment extends StatelessWidget {
  const SuccessPayment({super.key, required this.image, required this.title, required this.subTitle, required this.onPressed, required this.onPressed2});

  final String image, title, subTitle;
  final VoidCallback onPressed;
  final VoidCallback onPressed2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              /// Image
              Lottie.asset(image, width: MediaQuery.of(context).size.width * 0.6),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Title & SubTitle
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(subTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onPressed, child:Text(TTexts.backToHome)),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              /// Buttons2
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onPressed2, child:Text(TTexts.history)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
