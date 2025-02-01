import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/update_name_controller.dart';

class ChangeGender extends StatelessWidget {
  const ChangeGender({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());

    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Change Gender'.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            Text(
              'Select your gender for better personalization. You can update this later if needed.'.tr,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Form
            Form(
              key: controller.updateFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.userGender.text.isEmpty
                        ? null
                        : controller.userGender.text, // Pre-select current gender
                    items: ['Male'.tr, 'Female'.tr, 'Other'.tr]
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender.tr),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.userGender.text = value;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: TTexts.userGender,
                      prefixIcon: const Icon(Iconsax.user),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender.'.tr;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.updateFormKey.currentState!.validate()) {
                    controller.updateUserDetails();
                  }
                },
                child: Text('Save'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
