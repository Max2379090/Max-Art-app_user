import 'package:get/get.dart';
import '../../../../data/repositories/banners3/banner_repository3.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/banner_model3.dart';

class BannerController3 extends GetxController {
  final bannersLoading = false.obs;
  final carousalCurrentIndex = 0.obs;
  final RxList<BannerModel3> banners3 = <BannerModel3>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  /// Fetch banners from Firestore and update the 'banners' list
  Future<void> fetchBanners() async {
    try {
      // Start Loading
      bannersLoading.value = true;

      // Fetch Banners
      final bannerRepo = Get.put(BannerRepository3());
      final banners3 = await bannerRepo.fetchBanners();

      // Assign banners
      this.banners3.assignAll(banners3);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!'.tr, message: e.toString());
    } finally {
      bannersLoading.value = false;
    }
  }
}
