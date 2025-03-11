import 'package:Max_store/utils/constants/colors.dart';
import 'package:Max_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/personalization/screens/category/category.dart';
import 'features/personalization/screens/setting/settings.dart';
import 'features/shop/screens/favourites/favourite.dart';
import 'features/shop/screens/home/home.dart';
import 'features/shop/screens/store/store.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(AppScreenController());
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(
                () => NavigationBar(
              height: 70,
              animationDuration: const Duration(milliseconds: 300),
              selectedIndex: controller.selectedMenu.value,
              backgroundColor:dark ? TColors.darkerGrey : TColors.light,
              elevation: 5,
              indicatorColor: Colors.grey.withValues(alpha: 0.1),
              onDestinationSelected: (index) {
                // Prevent FAB tab index
                if (index != 2) controller.selectedMenu.value = index;
              },
              destinations: [
                NavigationDestination(icon: const Icon(Iconsax.home), label: 'Home'.tr),
                NavigationDestination(icon: const Icon(Iconsax.shop), label: 'Store'.tr),
                const NavigationDestination(icon: SizedBox(), label: 'Category'), // Empty space for FAB
                NavigationDestination(icon: const Icon(Iconsax.heart), label: 'Favorite'.tr),
                NavigationDestination(icon: const Icon(Iconsax.user), label: 'Profile'.tr),
              ],
            ),
          ),
          // Center FAB
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              onPressed: () {
                Get.to(() => CategoryScreen());
              },
              backgroundColor: dark ? TColors.darkerGrey : TColors.primary,
              child: const Icon(Iconsax.category, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Obx(() => controller.screens[controller.selectedMenu.value]),
    );
  }
}

class AppScreenController extends GetxController {
  static AppScreenController get instance => Get.find();

  final Rx<int> selectedMenu = 0.obs;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const SizedBox(), // Placeholder for FAB
    const FavouriteScreen(),
    const SettingsScreen(),
  ];
}
