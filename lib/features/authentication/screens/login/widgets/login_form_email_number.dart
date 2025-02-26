import 'package:country_code_text_field/country_code_text_field.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/login_in_controller.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';
import '../../signup/widgets/creat_gmail_OTP.dart';
import '../../signup/widgets/otp_page_email.dart';
import '../../signup/widgets/otp_page_number.dart';
import '../login_password.dart';

class LoginFormEmailNumber extends StatelessWidget {
  const LoginFormEmailNumber({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final RxBool isEmailSelected = false.obs;
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [

            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone, color: Colors.white), // Phone icon
                      const SizedBox(width: 2), // Space between icon and text
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

                SizedBox(width: 5),
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.email, color: Colors.white), // Email icon
                      const SizedBox(width: 2), // Space between icon and text
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
                  ?TextField(
    textAlign: TextAlign.left,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
    labelText: 'Enter your Email',
    border: const OutlineInputBorder(),
    prefixIcon: Icon(Icons.email, color: TColors.primary),
    suffixIcon: IconButton(
    icon: const Icon(Icons.send_rounded, color: TColors.primary),
    onPressed: () => Get.to(() => LoginPasswordScreen()),
    ),
    ),
    )
         
                  : CountryCodeTextField(
                keyboardType: TextInputType.number,


                decoration: InputDecoration(

                  suffixIcon: IconButton(
                    onPressed: () => Get.to(() =>  LoginPasswordScreen()),
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



            /// Email
           // TextFormField(
             // controller: controller.email,
            //  validator: TValidator.validateEmail,
            //  decoration:InputDecoration(prefixIcon: const Icon(Iconsax.direct_right), labelText: TTexts.email.tr),
           // ),
           // const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            //Obx(
                //  () => TextFormField(
               // obscureText: controller.hidePassword.value,
               // controller: controller.password,
              //  validator: (value) => TValidator.validateEmptyText('Password', value),
              //  decoration: InputDecoration(
               //   labelText: TTexts.password.tr,
               //   prefixIcon: const Icon(Iconsax.password_check),
               //   suffixIcon: IconButton(
                //    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  //  icon: const Icon(Iconsax.eye_slash),
                 // ),
               // ),
             // ),
           // ),
            const SizedBox(height: TSizes.spaceBtwInputFields ),

            /// Remember Me & Forget Password
            //Row(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
             // children: [
                /// Remember Me
               // Row(
                //  mainAxisSize: MainAxisSize.min,
                 // children: [
                  //  Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = value!)),
                  //  Text(TTexts.rememberMe.tr),
                 // ],
                //),

                /// Forget Password
                //TextButton(onPressed: () => Get.to(() => const ForgetPasswordScreen()), child:  Text(TTexts.forgetPassword.tr)),
             // ],
            //),
           // const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
           //SizedBox(
             // width: double.infinity,
             // child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: Text(TTexts.signIn.tr)),
           // ),
           // const SizedBox(height: TSizes.spaceBtwItems),

            /// Create Account Button
            //SizedBox(
            //  width: double.infinity,
             // child: OutlinedButton(onPressed: () => Get.to(() => const SignupScreen()), child: Text(TTexts.createAccount.tr)),

          //  ),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() =>Otp()), // Pass null
                child: Text(TTexts.createAccount.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
