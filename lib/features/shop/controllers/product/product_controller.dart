
import 'package:get/get.dart';

import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  /// -- Initialize Products from your backend
  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  /// Fetch Products using Stream so, any change can immediately take effect.
  void fetchFeaturedProducts() async {
    try {
      // Show loader while loading Products
      isLoading.value = true;

      // Fetch Products
      final products = await productRepository.getFeaturedProducts();

      // Assign Products
      featuredProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!'.tr, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Get the product price or price range for variations.
  /// Get the product price or price range for variations.
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0;

    // If no variations exist, return the simple price or sale price
    if (product.productType == ProductType.single.toString() || (product.productVariations?.isEmpty ?? true)) {
      // Use sale price if available; otherwise, use the regular price
      double price = product.salePrice > 0 ? product.salePrice : product.price;
      return price.toStringAsFixed(0);
    } else {
      // Calculate the smallest and largest prices among variations
      for (var variation in product.productVariations!) {
        // Determine the price to consider (sale price if available, otherwise regular price)
        double priceToConsider = variation.salePrice > 0 ? variation.salePrice : variation.price;

        // Update smallest and largest prices
        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      // If smallest and largest prices are the same, return a single price
      if ((smallestPrice - largestPrice).abs() < 0.01) { // Use a tolerance for floating-point comparison
        return largestPrice.toStringAsFixed(0);
      } else {
        // Otherwise, return a price range
        return '${smallestPrice.toStringAsFixed(0)} - ${largestPrice.toStringAsFixed(0)}';
      }
    }
  }


  /// -- Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// -- Check Product Stock Status
  String getProductStockStatus(ProductModel product) {
    if (product.productType == ProductType.single.toString()) {
      return product.stock > 0 ? 'In Stock'.tr : 'Out of Stock'.tr;
    } else {
      final stock = product.productVariations?.fold(0, (previousValue, element) => previousValue + element.stock);
      return stock != null && stock > 0 ? 'In Stock'.tr : 'Out of Stock'.tr;
    }
  }

  Future<void> updateProductStock(String productId, int quantitySold, String variationId) async {
    try {
      // Fetch Products
      final product = await productRepository.getSingleProduct(productId);

      if (variationId.isEmpty) {
        product.stock -= quantitySold;
        product.soldQuantity += quantitySold;

        await productRepository.updateProduct(product);
      } else {
        final variation = product.productVariations!.where((variation) => variation.id == variationId).first;
        variation.stock -= quantitySold;
        variation.soldQuantity += quantitySold;


        await productRepository.updateProduct(product);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!'.tr, message: e.toString());
    }
  }
}
