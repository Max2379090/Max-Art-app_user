import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/address_controller.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      appBar: TAppBar(showBackArrow: true, title: Text('Add new Address'.tr)),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.name,
                  validator: (value) => TValidator.validateEmptyText('Name'.tr, value),
                  decoration:  InputDecoration(prefixIcon: const Icon(Iconsax.user), labelText: 'Name'.tr),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: (value) => TValidator.validateEmptyText('Phone Number'.tr, value),
                  decoration: InputDecoration(prefixIcon: const Icon(Iconsax.mobile), labelText: 'Phone Number'.tr),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.street,
                        validator: (value) => TValidator.validateEmptyText('Street'.tr, value),
                        expands: false,
                        decoration: InputDecoration(
                          labelText: 'Street'.tr,
                          prefixIcon: const Icon(Iconsax.building_31),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.postalCode,
                        validator: (value) => TValidator.validateEmptyText('Postal Code'.tr, value),
                        expands: false,
                        decoration: InputDecoration(
                          labelText: 'Postal Code'.tr,
                          prefixIcon: const Icon(Iconsax.code),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.city,
                        validator: (value) => TValidator.validateEmptyText('City'.tr, value),
                        expands: false,
                        decoration: InputDecoration(
                          labelText: 'City'.tr,
                          prefixIcon: const Icon(Iconsax.building),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.state,
                        expands: false,
                        decoration: InputDecoration(
                          labelText: 'State'.tr,
                          prefixIcon: const Icon(Iconsax.activity),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.country,
                  validator: (value) => TValidator.validateEmptyText('Country'.tr, value),
                  decoration: InputDecoration(prefixIcon: const Icon(Iconsax.global), labelText: 'Country'.tr),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child:
                  ElevatedButton(onPressed: () => controller.addNewAddresses(), child: Text('Save'.tr)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
