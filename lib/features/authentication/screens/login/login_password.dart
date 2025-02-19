import 'package:Max_store/features/authentication/screens/login/widgets/login_form_email_number.dart';
import 'package:Max_store/features/authentication/screens/login/widgets/login_form_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginPasswordScreen extends StatelessWidget {
  const LoginPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///  Header
              const TLoginHeader(),

              /// Form
              LoginFormPassword (),
              //const TLoginForm(),
              //LoginFormEmailNumber(),

              /// Divider
              //TFormDivider(dividerText: TTexts.orSignInWith.tr),
              //const SizedBox(height: TSizes.spaceBtwSections),

              /// Footer
              //const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
