import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../screens/profile/profile.dart';
import 'user_controller.dart';

/// Controller to manage user-related functionality.
class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final phoneNumber = TextEditingController();
  final userGender = TextEditingController();
  final email = TextEditingController();
  final dateOfBirth = TextEditingController();

  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());

  final updateFormKey = GlobalKey<FormState>();

  /// Initialize user data when the screen appears.
  @override
  void onInit() {
    _initializeUserData();
    super.onInit();
  }

  /// Fetch user data and populate controllers.
  void _initializeUserData() {
    final user = userController.user.value;
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    username.text = user.username;
    email.text = user.email;
    phoneNumber.text = user.phoneNumber;
    dateOfBirth.text = user.dateOfBirth;
    userGender.text = user.usergender;
  }

  /// Update user details in Firestore.
  Future<void> updateUserDetails() async {
    if (!updateFormKey.currentState!.validate()) {
      return;
    }

    try {
      // Show loading dialog
      TFullScreenLoader.openLoadingDialog(
        'We are updating your information...'.tr,
        TImages.docerAnimation,
      );

      // Check network connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'No Internet'.tr,
          message: 'Please check your connection and try again.'.tr,
        );
        return;
      }

      // Prepare data to update
      final updatedData = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim(),
        'UserName': username.text.trim(),
        'UserGender': userGender.text.trim(),
        'PhoneNumber': phoneNumber.text.trim(),
        'DateOfBirth': dateOfBirth.text.trim(),
        'Email': email.text.trim(),
      };

      // Update data in Firestore
      await userRepository.updateSingleField(updatedData);

      // Update local user data
      userController.user.update((user) {
        if (user != null) {
          user.firstName = firstName.text.trim();
          user.lastName = lastName.text.trim();
          user.username = username.text.trim();
          user.usergender = userGender.text.trim();
          user.phoneNumber = phoneNumber.text.trim();
          user.dateOfBirth = dateOfBirth.text.trim();
          user.email = email.text.trim();
        }
      });

      // Success feedback
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Success'.tr,
        message: 'Your details have been successfully updated.'.tr,
      );

      // Navigate to the Profile screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      // Error feedback
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to update details: ${e.toString()}'.tr,
      );
    }
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    username.dispose();
    phoneNumber.dispose();
    userGender.dispose();
    email.dispose();
    dateOfBirth.dispose();
    super.onClose();
  }
}
