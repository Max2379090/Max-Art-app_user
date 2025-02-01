import 'dart:math';

import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/loaders.dart';
import '../../styles/spacing_styles.dart';

class TransactionValidation extends StatelessWidget {
  const TransactionValidation({super.key, required this.title, required this.subTitle, required this.subTitle2, });

  final title, subTitle,subTitle2;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight * 4.5,
          child: Column(
            children: [
              /// Image
              Transform.scale(
                scale: 1.75,
                child: const CircularProgressIndicator(color: Colors.green,),
              ),


              //Lottie.asset(image, width: MediaQuery.of(context).size.width * 0.6),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Title & SubTitle
              Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(subTitle, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(subTitle2, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),

              /// Buttons
               SizedBox(
                width: double.infinity,
                child:TweenAnimationBuilder<Duration>(
                    duration: const Duration(minutes: 2),
                    tween: Tween(begin: const Duration(minutes: 2), end: Duration.zero),
                    onEnd: () {TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
                    },
                    builder: (BuildContext context, Duration value, Widget? child) {

                      final minutes = value.inMinutes;
                      final seconds = value.inSeconds % 60;
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('$minutes:$seconds',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: TColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25)));
                    }),
              ),
            ],
          ),
        ),
      ),

    );
  }


}
