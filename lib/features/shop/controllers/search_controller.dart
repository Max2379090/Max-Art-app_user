import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/product/product_repository.dart';
import '../models/product_model.dart';

class TSearchController extends GetxController {
  static TSearchController get instance => Get.find();

  RxList<ProductModel> searchResults = <ProductModel>[].obs;
  RxBool isLoading = false.obs;
  RxString lastSearchQuery = ''.obs;
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = double.infinity.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  List<String> sortingOptions = [
    'Name'.tr,
    'Lowest Price'.tr,
    'Highest Price'.tr,
    'Popular'.tr,
    'Newest'.tr,
    'Suitable'.tr,
  ];
  RxString selectedSortingOption = 'Name'.tr.obs; // Correspond exactement à la liste.

  @override
  void onInit() {
    super.onInit();
    debugSortingOptions(); // Vérifier les doublons au démarrage.
  }

  // Fonction pour rechercher les produits.
  void search() {
    searchProducts(
      searchQuery.value,
      categoryId: selectedCategoryId.value.isNotEmpty ? selectedCategoryId.value : null,
      minPrice: minPrice.value != 0.0 ? minPrice.value : null,
      maxPrice: maxPrice.value != double.infinity ? maxPrice.value : null,
    );
  }

  void searchProducts(String query, {String? categoryId, String? brandId, double? minPrice, double? maxPrice}) async {
    lastSearchQuery.value = query;
    isLoading.value = true;

    try {
      final results = await ProductRepository.instance.searchProducts(
        query,
        categoryId: categoryId,
        brandId: brandId,
        maxPrice: maxPrice,
        minPrice: minPrice,
      );

      // Tri des résultats selon l'option sélectionnée.
      switch (selectedSortingOption.value) {
        case 'Name':
          results.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Lowest Price':
          results.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Highest Price':
          results.sort((a, b) => b.price.compareTo(a.price));
          break;
      // Ajouter d'autres cas si nécessaire.
        default:
          if (kDebugMode) {
            print('Unknown sorting option: ${selectedSortingOption.value}');
          }
      }

      searchResults.assignAll(results); // Mettre à jour les résultats.
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Fonction pour détecter les doublons dans les options de tri.
  void debugSortingOptions() {
    final duplicates = sortingOptions
        .fold<Map<String, int>>({}, (acc, item) {
      acc[item] = (acc[item] ?? 0) + 1;
      return acc;
    })
        .entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toList();

    if (duplicates.isNotEmpty) {
      if (kDebugMode) {
        print('Duplicate sorting options found: $duplicates');
      }
    }
  }
}

// Widget DropdownButton pour afficher les options de tri.
class SortingDropdown extends StatelessWidget {
  final TSearchController controller = TSearchController.instance;

   SortingDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButton<String>(
        value: controller.selectedSortingOption.value,
        onChanged: (newValue) {
          if (newValue != null) {
            controller.selectedSortingOption.value = newValue;
            controller.search(); // Relancer la recherche après modification.
          }
        },
        items: controller.sortingOptions.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      );
    });
  }
}
