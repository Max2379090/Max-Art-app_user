import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_controller.dart';
import 'change_email.dart';
import 'change_gender.dart';
import 'change_name.dart';
import 'change_nomberphone.dart';
import 'change_username.dart';
import 'date_of_birth.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Profile'.tr, style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(
                          () {
                        final networkImage = controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty ? networkImage : TImages.user;
                        return controller.imageUploading.value
                            ? const TShimmerEffect(width: 80, height: 80, radius: 80)
                            : TCircularImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty);
                      },
                    ),
                    TextButton(
                      onPressed: controller.imageUploading.value ? () {} : () => controller.uploadUserProfilePicture(),
                      child: Text('Change Profile Picture'.tr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              TSectionHeading(title: 'Profile Information'.tr, showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () => Get.to(() => const ChangeName()), title: 'Name'.tr, value: controller.user.value.fullName),
              TProfileMenu(onPressed: () => Get.to(() => const ChangeUsername()), title: 'Username'.tr, value: controller.user.value.username),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),


              TSectionHeading(title: 'Personal Information'.tr, showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () {}, title:'User ID'.tr, value: controller.user.value.id, icon: Iconsax.copy),
              TProfileMenu(onPressed: ()  => Get.to(() => const ChangeEmail()), title: 'E-mail'.tr, value: controller.user.value.email),
              TProfileMenu(onPressed: () => Get.to(() => const ChangeNumber()), title: 'Phone Number'.tr, value: controller.user.value.phoneNumber),
              TProfileMenu(onPressed: () => Get.to(() => const ChangeGender()), title: 'Gender'.tr, value: controller.user.value.usergender),
              TProfileMenu(onPressed: () => Get.to(() => const DateOfBirth()), title: 'Date of Birth'.tr, value: controller.user.value.dateOfBirth),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: TextButton(
                    onPressed: () => controller.deleteAccountWarningPopup(),
                    child: Text('Close Account'.tr, style: const TextStyle(color: Colors.red))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
