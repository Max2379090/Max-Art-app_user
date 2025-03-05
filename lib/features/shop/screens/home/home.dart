import 'package:Max_store/features/shop/screens/home/widgets/promo_slider2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/brands/brand_card.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/shimmers/brands_shimmer.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/device/device_utility.dart';
import '../../controllers/brand_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../all_products/all_products.dart';
import '../billpayment/billpayment.dart';
import '../billpayment/liste_for_all_service.dart';
import '../brand/all_brands.dart';
import '../brand/brand.dart';
import '../favourites/favourite.dart';
import '../ticket_office/ticket_office_all.dart';
import '../ticket_office/ticket_office_screen.dart';
import 'widgets/header_categories.dart';
import 'widgets/header_search_container.dart';
import 'widgets/home_appbar.dart';
import 'widgets/promo_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final productController = Get.put(ProductController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildBody(context, brandController, productController),
          ],
        ),
      ),
    );
  }

  /// Build the header section with AppBar, Search bar, and Categories.
  Widget _buildHeader() {
    return TPrimaryHeaderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const THomeAppBar(),
          const SizedBox(height: TSizes.spaceBtwSections),
          TSearchContainer(text: 'Search in Store'.tr, showBorder: false),
          const SizedBox(height: TSizes.spaceBtwSections),
          const THeaderCategories(),
          const SizedBox(height: TSizes.spaceBtwSections * 2),
        ],
      ),
    );
  }

  /// Build the body section with sliders, products, and featured brands.
  Widget _buildBody(
      BuildContext context, BrandController brandController, ProductController productController) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TPromoSlider(),
          const SizedBox(height: TSizes.spaceBtwSections),
          _buildSectionHeading(
            context,
            title: TTexts.popularProducts,
            onPressed: () => Get.to(
                  () => AllProducts(
                title: TTexts.popularProducts,
                futureMethod: ProductRepository.instance.getAllFeaturedProducts(),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildFeaturedProducts(context, productController),
          const SizedBox(height: TSizes.spaceBtwSections),
          const TPromoSlider2(),
          const SizedBox(height: TSizes.spaceBtwSections),

          _buildSectionHeading(
            context,
            title: 'Bill payment'.tr,
            onPressed: () => Get.to(() =>  ListeForAllService()),
          ),
          BillPaymentScreen(),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildSectionHeading(
            context,
            title: 'Ticket office'.tr,
            onPressed: () => Get.to(() =>  TicketOfficeAll()),
          ),
          TicketOfficeScreen(),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildSectionHeading(
            context,
            title: 'Featured Brands'.tr,
            onPressed: () => Get.to(() => const AllBrandsScreen()),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildFeaturedBrands(context, brandController),
          SizedBox(height: TDeviceUtils.getBottomNavigationBarHeight() + TSizes.defaultSpace),
        ],
      ),
    );
  }

  /// Build a section heading with title and navigation action.
  Widget _buildSectionHeading(BuildContext context, {required String title, required VoidCallback onPressed}) {
    return TSectionHeading(title: title, onPressed: onPressed);
  }

  /// Build the featured products grid or show a loading shimmer.
  Widget _buildFeaturedProducts(BuildContext context, ProductController controller) {
    return Obx(() {
      if (controller.isLoading.value) return const TVerticalProductShimmer();

      if (controller.featuredProducts.isEmpty) {
        return Center(
          child: Text(
            'No Data Found!'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }

      return TGridLayout(
        itemCount: controller.featuredProducts.length,
        itemBuilder: (_, index) => TProductCardVertical(
          product: controller.featuredProducts[index],
          isNetworkImage: true,
        ),
      );
    });
  }

  /// Build the featured brands grid or show a loading shimmer.
  Widget _buildFeaturedBrands(BuildContext context, BrandController controller) {
    return Obx(() {
      if (controller.isLoading.value) return const TBrandsShimmer();

      if (controller.featuredBrands.isEmpty) {
        return Center(
          child: Text(
            'No Data Found!'.tr,
            style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
          ),
        );
      }

      return TGridLayout(
        itemCount: 4,
        mainAxisExtent: 80,
        itemBuilder: (_, index) {
          final brand = controller.featuredBrands[index];
          return TBrandCard(
            brand: brand,
            showBorder: true,
            onTap: () => Get.to(() => BrandScreen(brand: brand)),
          );
        },
      );
    });
  }
}
