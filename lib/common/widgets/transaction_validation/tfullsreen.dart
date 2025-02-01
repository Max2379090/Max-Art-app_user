import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

/// A utility class for managing a full-screen loading dialog.
class Tfullsreen{
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  ///   - text: The text to be displayed in the loading dialog.
  ///   - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String image,String title,String subTitle, String subTitle2) {
    showDialog(
      context: Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible: false, // The dialog can't be dismissed by tapping outside it
      builder: (_) => PopScope(
        canPop: false, // Disable popping with the back button
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!) ? TColors.dark : TColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              /// Image
              Lottie.asset(image, width: MediaQuery.of(context as BuildContext).size.width * 0.6),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Title & SubTitle
              Text(title, style: Theme.of(context as BuildContext).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(subTitle, style: Theme.of(context as BuildContext).textTheme.bodySmall, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(subTitle2, style: Theme.of(context as BuildContext).textTheme.bodySmall, textAlign: TextAlign.center),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child:TweenAnimationBuilder<Duration>(
                    duration: const Duration(minutes: 2),
                    tween: Tween(begin: const Duration(minutes: 2), end: Duration.zero),
                    onEnd: () {
                      print('Timer ended');
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

  /// Stop the currently open loading dialog.
  /// This method doesn't return anything.
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop(); // Close the dialog using the Navigator
  }
}
