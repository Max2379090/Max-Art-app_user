import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/general_bindings.dart';
import 'features/authentication/screens/change_language/LocaleString.dart';
import 'routes/app_routes.dart';
import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      theme: TAppTheme.lightTheme,
      themeMode: ThemeMode.system,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      translations: Localestring(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      defaultTransition: Transition.fade,
      initialBinding: GeneralBindings(),
      getPages: AppRoutes.pages,

      /// Show Loader or Circular Progress Indicator meanwhile Authentication Repository is deciding to show relevant screen.
      home: const Scaffold(backgroundColor: TColors.primary,
          body: Center(child: CircularProgressIndicator(color: Colors.white))),
    );
  }
}