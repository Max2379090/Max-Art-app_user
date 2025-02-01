import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/shimmers/search_category_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../shop/controllers/categories_controller.dart';
import '../../../shop/screens/all_products/all_products.dart';
import '../../../shop/screens/home/widgets/header_search_container.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final categoryController = CategoryController.instance;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Categories'.tr,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
              vertical: TSizes.spaceBtwItems,
            ),
            child: TSearchContainer(
              text: 'Search in Category'.tr,
              showBorder: false,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
            child: TSectionHeading(title: 'All Categories'.tr, showActionButton: false),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (categoryController.isLoading.value) {
                return const TSearchCategoryShimmer();
              }

              if (categoryController.allCategories.isEmpty) {
                return _buildNoDataFound(context);
              }

              final categories = categoryController.allCategories;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                  vertical: 10,
                ),
                separatorBuilder: (_, __) => Divider(
                  color: isDark ? TColors.grey : TColors.lightGrey,
                  thickness: 0.5,
                  height: 2,
                ),
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  final category = categories[index];
                  return _buildCategoryCard(context, category, isDark);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox, size: 80, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            'No Data Found!'.tr,
            style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, dynamic category, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: InkWell(
        onTap: () => Get.to(
              () => AllProducts(
            title: category.name,
            futureMethod: categoryController.getCategoryProducts(categoryId: category.id),
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TCircularImage(
                width: 50,
                height: 50,
                padding: 0,
                isNetworkImage: true,
                overlayColor: isDark ? TColors.white : TColors.primary,
                image: category.image.isNotEmpty ? category.image : 'https://fallback-image-url.com',
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.white : TColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
