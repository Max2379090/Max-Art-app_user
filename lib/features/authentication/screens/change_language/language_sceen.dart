import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';


class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageState();
}

class _LanguageState extends State<LanguageScreen> {

  final List locale =[
    {'name':'English','locale': const Locale('en','US')},
    {'name':'Français','locale': const Locale('fr','FR')},
  ];

  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return ElevatedButton(
        onPressed:() {buildLanguageDialog(context);},
        style: ElevatedButton.styleFrom(side: const BorderSide(
          color: Colors.transparent, //color
        ), backgroundColor: Colors.transparent),
        child: Wrap(
          children: <Widget>[
            Icon(
              Icons.language,
              color: dark ? TColors.primary : TColors.secondary2,
              size:20,
            ),
            const SizedBox(
              width:10,
            ),
            Text('English'.tr , style:  TextStyle(fontSize:15, color:dark ? TColors.primary : TColors.secondary2),),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: dark ? TColors.primary : TColors.secondary2,
              size: 25,
            ),

          ],
        )
    );
  }

  // Method to build the language selection dialog
  buildLanguageDialog(BuildContext context) {
    final List<Map<String, dynamic>> locales = [
      {'name': 'English', 'locale': const Locale('en', 'US'), 'flag': 'assets/flags/us.png'},
      {'name': 'Français', 'locale': const Locale('fr', 'FR'), 'flag': 'assets/flags/fr.png'},
    ];
    final dark = THelperFunctions.isDarkMode(context);
    showModalBottomSheet(

      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            decoration:  BoxDecoration(
              color: dark ? TColors.black : TColors.light,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TSectionHeading(title: 'Choose Your Language'.tr, showActionButton: false),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Add flag image
                              Image.asset(
                                locales[index]['flag'],
                                width: 30, // Adjust width as necessary
                                height: 20, // Adjust height as necessary
                              ),
                              const SizedBox(width: 8), // Space between flag and text
                              Text(
                                locales[index]['name'],
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Get.updateLocale(locales[index]['locale']);
                          Get.back();
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: Colors.grey);
                    },
                    itemCount: locales.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}




