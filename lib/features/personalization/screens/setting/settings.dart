import '../../../../common/widgets/list_tiles/setting_notification.dart';
import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return PopScope(
      canPop: false,
      onPopInvoked: (value) async => Get.offAll(const HomeMenu()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    TAppBar(
                      title: Text(
                        'Account'.tr,
                        style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white),
                      ),
                    ),
                    TUserProfileTile(onPressed: () => Get.to(() => const ProfileScreen())),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      onTap: () => Get.to(() => Notifications()),
                    ),
                    TSettingsMenuTile(
                      icon: Icons.headset_mic_outlined,
                      title: 'Contact Us'.tr,
                      subTitle: 'Contact our customer service if you have any problems'.tr,
                      onTap: () => Get.to(() => const SupportScreen()),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TSectionHeading(title: 'App Settings'.tr, showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.translate,
                      title: 'Change Language'.tr,
                      subTitle: 'Select your preferred language'.tr,
                      onTap: () => _buildLanguageDialog(context),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => controller.logout(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red), // Red border
                          foregroundColor: Colors.red, // Red text color
                        ),
                        child: Text('Logout'.tr),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Center(
                      child: Text(
                        'Version $_appVersion',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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

  void _buildLanguageDialog(BuildContext context) {
    final List<Map<String, dynamic>> locales = [
      {'name': 'English', 'locale': const Locale('en', 'US')},
      {'name': 'Français', 'locale': const Locale('fr', 'FR')},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: locales.map((locale) => ListTile(
                title: Text(locale['name']),
                onTap: () {
                  Get.updateLocale(locale['locale']);
                  Get.back();
                },
              )).toList(),
            ),
          ),
        );
      },
    );
  }
}
