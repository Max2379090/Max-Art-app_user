import 'package:get/get.dart';
import '../../../data/repositories/categories/category_repository.dart';
import '../../../data/repositories/product/product_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  RxBool isLoading = true.obs;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> filteredCategories = <CategoryModel>[].obs; // Holds search/filter results
  final _categoryRepository = Get.put(CategoryRepository());

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  /// -- Load category data
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true; // Show loader while loading categories

      // Fetch categories from data source (Firestore, API, etc.)
      final fetchedCategories = await _categoryRepository.getAllCategories();

      // Update the categories list
      allCategories.assignAll(fetchedCategories);
      filteredCategories.assignAll(fetchedCategories); // Initially, show all categories

      // Filter featured categories
      featuredCategories.assignAll(
        allCategories
            .where((category) => (category.isFeatured) && category.parentId.isEmpty)
            .take(8)
            .toList(),
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!'.tr, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// -- Load selected category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!'.tr, message: e.toString());
      return [];
    }
  }

  /// -- Get Category or Sub-Category Products
  /// If you want to fetch all the products in this category SET [limit] to -1
  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = 4}) async {
    final products = await ProductRepository.instance.getProductsForCategory(categoryId: categoryId, limit: limit);
    return products;
  }

  /// -- Search categories
  void searchCategories(String query) {
    if (query.isEmpty) {
      // Show all categories if the search query is empty
      filteredCategories.assignAll(allCategories);
    } else {
      // Filter categories based on the search query (case insensitive)
      filteredCategories.assignAll(
        allCategories.where(
              (category) => category.name.toLowerCase().contains(query.toLowerCase()),
        ).toList(),
      );
    }
  }

  /// -- Filter categories
  void filterCategories({String? parentId, bool? isFeatured}) {
    filteredCategories.assignAll(
      allCategories.where((category) {
        // Filter by parentId if provided
        final parentMatch = parentId == null || category.parentId == parentId;

        // Filter by isFeatured if provided
        final featuredMatch = isFeatured == null || category.isFeatured == isFeatured;

        return parentMatch && featuredMatch;
      }).toList(),
    );
  }
}
