import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/repositories/product/product_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/product_model.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      if(query == null) return [];
      return await repository.fetchProductsByQuery(query);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!'.tr, message: e.toString());
      return [];
    }
  }

  void assignProducts(List<ProductModel> products) {
    // Assign products to the 'products' list
    this.products.assignAll(products);
    sortProducts('Nom');
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;

    switch (sortOption) {
      case 'Nom':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Prix plus élevé':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Prix plus bas':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Plus récent':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'Solde':
        products.sort((a, b) {
          if (b.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;
      default:
        // Default sorting option: Name
        products.sort((a, b) => a.title.compareTo(b.title));
    }
  }
}
