import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../home_menu.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../../shop/screens/home/home.dart';
import '../../../controllers/login_in_controller.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';
import '../../signup/widgets/creat_gmail_OTP.dart';
import '../../signup/widgets/otp_page_email.dart';

class LoginFormPassword extends StatelessWidget {
  const LoginFormPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
           // TextFormField(
             // controller: controller.email,
             // validator: TValidator.validateEmail,
             // decoration:InputDecoration(prefixIcon: const Icon(Iconsax.direct_right), labelText: TTexts.email.tr),
           // ),


            /// Password
            Obx(
                  () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator: (value) => TValidator.validateEmptyText('Password', value),
                decoration: InputDecoration(
                  labelText: TTexts.password.tr,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: const Icon(Iconsax.eye_slash),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = value!)),
                    Text(TTexts.rememberMe.tr),
                  ],
                ),

                /// Forget Password
                TextButton(onPressed: () => Get.to(() => const ForgetPasswordScreen()), child:  Text(TTexts.forgetPassword.tr)),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () =>
                  Get.to(() => HomeMenu()),
                  //controller.emailAndPasswordSignIn(),
                  child: Text(TTexts.signIn.tr)),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Create Account Button
           // SizedBox(
            //  width: double.infinity,
            //  child: OutlinedButton(onPressed: () => Get.to(() => const SignupScreen()), child: Text(TTexts.createAccount.tr)),

            //),

            //SizedBox(
             // width: double.infinity,
             // child: OutlinedButton(
              //  onPressed: () => Get.to(() =>Otp()), // Pass null
               // child: Text(TTexts.createAccount.tr),
             // ),
           // ),
          ],
        ),
      ),
    );
  }
}
