import '../../../../common/widgets/list_tiles/setting_notification.dart';
import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
// Import for launching URLs

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../home_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../shop/screens/cart/cart.dart';
import '../../../shop/screens/contact_us/contact_us.dart';
import '../../../shop/screens/coupon/coupon.dart';
import '../../../shop/screens/notification/notification.dart';
import '../../../shop/screens/order/order.dart';
import '../../../shop/screens/payment_detail/payment_liste.dart';
import '../../controllers/user_controller.dart';
import '../address/address.dart';
import '../profile/profile.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return PopScope(
      canPop: false,
      // Intercept the back button press and redirect to Home Screen
      onPopInvoked: (value) async => Get.offAll(const HomeMenu()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// -- Header
              TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    /// AppBar
                    TAppBar(
                      title: Text(
                        'Account'.tr,
                        style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white),
                      ),
                    ),

                    /// User Profile Card
                    TUserProfileTile(onPressed: () => Get.to(() => const ProfileScreen())),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),

              /// -- Profile Body
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// -- Account  Settings
                    TSectionHeading(title: 'Account Settings'.tr, showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.safe_home,
                      title: 'My Addresses'.tr,
                      subTitle: 'Set shopping delivery address'.tr,
                      onTap: () => Get.to(() => const UserAddressScreen()),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.shopping_cart,
                      title: 'My Cart'.tr,
                      subTitle: 'Add, remove products and move to checkout'.tr,
                      onTap: () => Get.to(() => const CartScreen()),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.bag_tick,
                      title: 'My Orders'.tr,
                      subTitle: 'In-progress and Completed Orders'.tr,
                      onTap: () => Get.to(() => const OrderScreen()),
                    ),
                    // TSettingsMenuTile(
                    //   icon: Iconsax.bank,
                    //   title: 'Bank Account'.tr,
                    //  subTitle: 'Withdraw balance to registered bank account'.tr,
                    //   onTap: () => Get.to(() => const Wallet()),
                    // ),
                    TSettingsMenuTile(
                      icon: Iconsax.wallet,
                      title: 'My History payment'.tr,
                      subTitle: 'Order Payment History'.tr,
                      onTap: () => Get.to(() => const PaymentListScreen()),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.discount_shape,
                      title: 'My Coupons'.tr,
                      subTitle: 'List of all the discounted coupons'.tr,
                      onTap: () => Get.to(() => const CouponScreen()),
                    ),
                    TSettingsMenuNotification(
                      icon: Iconsax.notification,
                      title: 'Notifications'.tr,
                      subTitle: 'Set any kind of notification message'.tr,
                      onTap: () => Get.to(() => const Notifications()),
                    ),
                    //TSettingsMenuTile(
                    //  icon: Iconsax.security_card,
                     // title: 'Account Privacy'.tr,
                    //  subTitle: 'Manage data usage and connected accounts'.tr,
                     // onTap: () => Get.to(() => const AccountPrivacyPage()),
                   // ),

                    TSettingsMenuTile(
                      icon: Icons.headset_mic_outlined,
                      title: 'Contact Us'.tr,
                      subTitle: 'contact our customer service if you have any problems'.tr,
                      onTap: () => Get.to(() => const SupportScreen()),
                    ),

                    /// -- App Settings
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TSectionHeading(title: 'App Settings'.tr, showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.translate,
                      title: 'Change Language'.tr,
                      subTitle: 'Select your preferred language'.tr,
                      onTap: () {
                        // Call the method to show language dialog instead of navigating
                        _buildLanguageDialog(context);
                      },
                    ),
                    // const SizedBox(height: TSizes.spaceBtwItems),
                    // TSettingsMenuTile(
                     //icon: Iconsax.document_upload,
                    // title: 'Load Data',
                    // subTitle: 'Upload Data to your Cloud Firebase',
                     // onTap: () => Get.to(() => const UploadDataScreen()),
                   // ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    //const SizedBox(height: TSizes.spaceBtwItems),
                    // TSettingsMenuTile(
                    //  icon: Iconsax.translate,
                    //  title: 'Change Language',
                    // subTitle: 'Select your preferred language',
                    // onTap: () => Get.to(() =>  LocationPage()),
                    // ),
                    // TSettingsMenuTile(
                    //  icon: Iconsax.location,
                    //  title: 'Geolocation',
                    // subTitle: 'Set recommendation based on location',
                    // trailing: Switch(value: true, onChanged: (value) {}),
                    // ),
                    //TSettingsMenuTile(
                    //icon: Iconsax.security_user,
                    // title: 'Safe Mode',
                    //subTitle: 'Search result is safe for all ages',
                    //trailing: Switch(value: false, onChanged: (value) {}),
                    // ),
                    //TSettingsMenuTile(
                    // icon: Iconsax.image,
                    //  title: 'HD Image Quality',
                    //  subTitle: 'Set image quality to be seen',
                    // trailing: Switch(value: false, onChanged: (value) {}),
                    //),

                    /// -- Logout Button
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => controller.logout(),
                        child:  Text('Logout'.tr),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),

    );
  }

  // Method to build the language selection dialog
  void _buildLanguageDialog(BuildContext context) {

    final List<Map<String, dynamic>> locales = [
      {'name': 'English', 'locale': const Locale('en', 'US'), 'flag': 'assets/flags/us.png'},
      {'name': 'Français', 'locale': const Locale('fr', 'FR'), 'flag': 'assets/flags/fr.png'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        final isDark = THelperFunctions.isDarkMode(context);
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? TColors.darkerGrey : TColors.light,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
