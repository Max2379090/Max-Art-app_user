import 'package:Max_store/features/authentication/screens/login/widgets/login_form_email_number.dart';
import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_styles.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///  Header
              const TLoginHeader(),

              /// Form
              //const TLoginForm(),
              LoginFormEmailNumber(),

              /// Divider
              //TFormDivider(dividerText: TTexts.orSignInWith.tr),
              //const SizedBox(height: TSizes.spaceBtwSections),

              /// Footer
              //const TSocialButtons(),
              //const SizedBox(height: 190),
            ],
          ),
        ),
      ),
      ));
  }
}
