import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'creat_compte_with_email.dart';
import 'widgets/signup_form.dart';

class SignupEmailScreen extends StatelessWidget {
  const SignupEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///  Title
              Text(TTexts.signupTitle.tr, style: Theme.of(context).textTheme.headlineMedium),

              /// Form
              const  CreatCompteWithEmail(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Divider
              //TFormDivider(dividerText: TTexts.orSignUpWith.tr),
              //const SizedBox(height: TSizes.spaceBtwSections),

              /// Social Buttons
              //const TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
