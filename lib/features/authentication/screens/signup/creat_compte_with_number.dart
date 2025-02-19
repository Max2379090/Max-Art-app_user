import 'package:Max_store/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../controllers/signup_controller.dart';

class CreatCompteWithNumber extends StatelessWidget {
  const CreatCompteWithNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          const SizedBox(height: TSizes.spaceBtwSections),

          /// First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => TValidator.validateEmptyText('First name', value),
                  decoration: InputDecoration(labelText: TTexts.firstName.tr, prefixIcon: const Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => TValidator.validateEmptyText('Last name', value),
                  decoration: InputDecoration(labelText: TTexts.lastName.tr, prefixIcon: const Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Username
          TextFormField(
            controller: controller.username,
            validator: TValidator.validateUsername,
            decoration: InputDecoration(labelText: TTexts.username.tr, prefixIcon: const Icon(Iconsax.user_edit)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: TValidator.validateEmail,
            decoration:InputDecoration(labelText: TTexts.email.tr, prefixIcon: const Icon(Iconsax.direct)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          /// Phone Number
          

          /// City
          TextFormField(
            controller: controller.city,  // Ensure controller has a city field
            validator: (value) => TValidator.validateEmptyText('City', value),
            decoration: InputDecoration(labelText: 'City', prefixIcon: const Icon(Iconsax.location)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Gender Selection
          Obx(
                () => DropdownButtonFormField<String>(
              value: controller.selectedGender.value,
              onChanged: (value) => controller.selectedGender.value = value!,
              items: ['Male', 'Female']
                  .map((gender) => DropdownMenuItem(value: gender, child: Text(gender.tr)))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Gender',
                prefixIcon: const Icon(Iconsax.user_octagon),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Date of Birth
          Obx(
                () => TextFormField(
              readOnly: true,
              controller: TextEditingController(text: controller.dateOfBirth.value),
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: const Icon(Iconsax.calendar),
                suffixIcon: IconButton(
                  icon: const Icon(Iconsax.calendar_1),
                  onPressed: () => controller.pickDateOfBirth(context),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Please select your date of birth' : null,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Password
          Obx(
                () => TextFormField(
              controller: controller.password,
              validator: TValidator.validatePassword,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password.tr,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Terms & Conditions Checkbox
          const TTermsAndConditionCheckbox(),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: Text(TTexts.createAccount.tr),
            ),
          ),
        ],
      ),
    );
  }
}
